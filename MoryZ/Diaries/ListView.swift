//
//  ListView.swift
//  MoryZ
//
//  Created by 周源坤 on 2021/12/1.
//

import SwiftUI
import CoreData

struct ListView: View {
    
    //UserDefault: Background
    @AppStorage("wallpaperLightURL") var wallpaperLightURL: URL?
    @AppStorage("wallpaperDarkURL") var wallpaperDarkURL: URL?
    //UserDefault: Predicate & Sort
    @AppStorage("selectedPredicate") var selectedPredicate: DisplayMode = .monthly
    @AppStorage("ascending") var ascending: Bool = false
    //Environment: ColorScheme, CoreData
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    //State: Background, Write Today Diary
    @State var photoBackground: UIImage? = nil
    
    @State private var presentedDiaries = [Diary]()
    
    

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Diary.date, ascending: true)],
        animation: .default
        )
    private var diaries: FetchedResults<Diary>
    
    @State private var searchText = ""
    
    @discardableResult
    func getTodayDiary() -> Diary? {
        let fetchRequest: NSFetchRequest<Diary> = Diary.fetchRequest()
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        let dateFrom = calendar.startOfDay(for: Date())
        let predicate = NSPredicate(format: "date >= %@", dateFrom as NSDate)
        fetchRequest.predicate = predicate
        
        let result = try! viewContext.fetch(fetchRequest)
        if result.isEmpty {
            return nil
        } else {
            return result.first!
        }
    }
    
    @discardableResult
    func getOrCreateTodayDiary() -> Diary {
        if let diary = getTodayDiary() {
            return diary
        }
        let newDiary = Diary(context: viewContext)
        newDiary.date = Date()
        newDiary.weather = "🌤"
        newDiary.title = String(localized: "Title")
        newDiary.content = String(localized: "sample text")
        newDiary.mood = "😄"
        newDiary.mean = "✨"
        newDiary.lastModifiedTime = Date()
        try! viewContext.save()
        return newDiary
    }
    
    var searchResults: [Diary] {
            if searchText.isEmpty {
                return diaries.filter { $0 === $0 }
            } else {
                return diaries.filter { $0.title!.contains(searchText) }
            }
        }
    
    var body: some View {
        
        NavigationStack(path: $presentedDiaries) {
            ScrollView {
                Spacer()
                
                ForEach(searchResults) { diary in
                    NavigationLink(value: diary) {
                        RowView(diary: diary, onSwipeAndTapped: { diary in
                            viewContext.delete(diary)
                            try! viewContext.save()
                        })
                    }
                }
                .navigationDestination(for: Diary.self) { diary in
                    EditView(diary: diary)
                }
                
            }
            
//                .searchable(text: $searchText) {
//                    ForEach(searchResults) { result in
//                        Text("Are you looking for \(result.title!)?").searchCompletion(result.title!)
//                    }
//                }
            .background(
                Image(uiImage: photoBackground ?? UIImage(named: "day")!)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            )
            .onAppear {
                diaries.nsPredicate = nil
                diaries.nsSortDescriptors = [NSSortDescriptor(keyPath: \Diary.date, ascending: ascending)]
                diaries.nsPredicate = selectedPredicate.predicate
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: SettingsView()) {
                        Label("Settings", systemImage: "gear")
                    }
                    
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        //TODO: filter diaries
                        
                    }) {
                        Image(systemName: "line.3.horizontal.decrease")
                    }
                }
                ToolbarItem {
                    Button {
                        presentedDiaries.append(getOrCreateTodayDiary())
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("Diary")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: colorScheme, perform: { newValue in
                if newValue == .light {
                    if let wallpaperLightURL = wallpaperLightURL, let data = try?  Data(contentsOf: wallpaperLightURL) {
                        photoBackground = UIImage(data: data)!
                    } else {
                        photoBackground = UIImage(named: "day")
                    }
                } else if newValue == .dark {
                    if let wallpaperDarkURL = wallpaperDarkURL, let data = try? Data(contentsOf: wallpaperDarkURL) {
                        photoBackground = UIImage(data: data)!
                    } else {
                        photoBackground = UIImage(named: "night")
                    }
                }
            })
            .onAppear {
                if colorScheme == .light {
                    if let wallpaperLightURL = wallpaperLightURL, let data = try?  Data(contentsOf: wallpaperLightURL) {
                        photoBackground = UIImage(data: data)!
                    } else {
                        photoBackground = UIImage(named: "day")
                    }
                } else if colorScheme == .dark {
                    if let wallpaperDarkURL = wallpaperDarkURL, let data = try? Data(contentsOf: wallpaperDarkURL) {
                        photoBackground = UIImage(data: data)!
                    } else {
                        photoBackground = UIImage(named: "night")
                    }
                }
            }
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
            
    }
}

// Width: 414.0
// Height: 896.0
