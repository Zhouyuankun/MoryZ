//
//  SettingsView.swift
//  MoryZ
//
//  Created by 周源坤 on 2021/12/1.
//

import SwiftUI
import UniformTypeIdentifiers
import CoreData

struct SettingsView: View {
    
    // @AppStorage("wallpaper") var wallpaper
    @State var showDiaryToJSON = false
    @State var showJSONToDiary = false
    @Environment(\.managedObjectContext) private var viewContext
    @State var showActivity = false
    @State var historyDate: Date = Date()
    @State var showEditView: Bool = false
    @State var editedDiary: Diary?
   
    @State var filepath: URL?
    
    @AppStorage("selectedPredicate") var selectedPredicateNum: DisplayMode = .monthly
    @AppStorage("ascending") var ascending: Bool = false
    @AppStorage("reminderEnable") var reminderEnable: Bool = false
    
    var body: some View {
        ZStack {
            
            List {
                    Section(content: {
                        NavigationLink(destination: {
                            SettingsWallpaperView(selectedLightPhoto: UIImage(named: "day")!, selectedDarkPhoto: UIImage(named: "night")!)
                        }) {
                            SettingRowView(color: .blue, icon: "seal", settingName: String(localized: "background"))
                        }
                    }, header: {
                        Text("Appearance")
                    })
                    .blur(radius: showActivity ? 5 : 0)
                    
                    Section(content: {
                        Picker("", selection: $selectedPredicateNum) {
                          ForEach(DisplayMode.allCases) { displayMode in
                            Text(displayMode.name).tag(displayMode)
                          }          }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        Toggle("Sort inverse", isOn: $ascending)
                    }, header: {
                        Text("Display Mode")
                    })
                    .blur(radius: showActivity ? 5 : 0)
                    
                    Section(content: {
                        
                        SettingRowView(color: .purple, icon: "arrow.uturn.backward", settingName: String(localized: "Convert diaries to JSON"))
                            .onTapGesture {
                                showDiaryToJSON = true
                            }
                            .sheet(isPresented: $showDiaryToJSON) {
                                let fetchRequest = Diary.fetchRequest()
                                let result = try! viewContext.fetch(fetchRequest)
                                let data = diariesToJSON(diaries: result)
                                ActivityViewController(activityItems: [data])
                            }
                        
                        SettingRowView(color: .yellow, icon: "arrow.uturn.forward", settingName: String(localized: "Convert JSON to diaries"))
                            .onTapGesture {
                                showJSONToDiary = true
                            }
                            .sheet(isPresented: $showJSONToDiary) {
                                DocumentPicker(documentTypes: [.data], onDocumentsPicked: { url in
                                    do {
                                        let data = try Data(contentsOf: url)
                                        dataConvertToManagedObjectContext(data: data)
                                    } catch let error as NSError {
                                        print(error)
                                    }
                                })
                            }
                            
                    }, header: {
                        Text("Export & Import")
                    })
                    .blur(radius: showActivity ? 5 : 0)
                
                Section(content: {
                    SettingRowView(color: .green, icon: "gobackward", settingName: String(localized: "Create history diary entry"))
                    HStack {
                        DatePicker("Date:", selection: $historyDate, displayedComponents: .date)
                            
                        Button(action: {
                            let newDiary = Diary(context: viewContext)
                            newDiary.date = historyDate
                            newDiary.weather = "🌤"
                            newDiary.title = String(localized: "Title")
                            newDiary.content = String(localized: "sample text")
                            newDiary.mood = "😄"
                            newDiary.mean = "✨"
                            newDiary.lastModifiedTime = Date()
                            try! viewContext.save()
                        }) {
                            Text("Create")
                        }

                    }
                    
                    SettingRowView(color: .brown, icon: "bell", settingName: String(localized: "Back up reminder"))
                    Toggle("Reminder status:", isOn: $reminderEnable)
                        .onChange(of: reminderEnable, perform: { _ in
                            if reminderEnable {
                                LocalNotifications.shared.createReminder()
                            } else {
                                LocalNotifications.shared.deleteReminder()
                            }
                        })
                    
                    SettingRowView(color: .red, icon: "trash", settingName: String(localized: "Delete all diaries"))
                        .onTapGesture {
                            let fetchRequest: NSFetchRequest<Diary> = Diary.fetchRequest()
                            let results = try! viewContext.fetch(fetchRequest)
                            for result in results {
                                viewContext.delete(result)
                            }
                        }
                    
                }, header: {
                    Text("Diaries")
                })
                .blur(radius: showActivity ? 5 : 0)
                
                Section(content: {
                    NavigationLink(destination: {
                        SettingsAboutView()
                    }, label: {
                        SettingRowView(color: Color.teal, icon: "person", settingName: String(localized: "About"))
                    })
                    
                }, header: {
                    Text("Author")
                })
                    .blur(radius: showActivity ? 5 : 0)
                    
                }
            
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
                .background(Color.white)
                
            
            ActivityIndicator(animate: $showActivity, style: .large)
        }
        
    }
    
    func diariesToJSON(diaries: [Diary]) -> Data? {
        var data: Data? = nil
        let diaryModels = diaries.map {createDiaryModelFromDiary(diary: $0)}
        let diaryModelWrapper = DiaryModelWrapper(diaries: diaryModels, createdDate: Date())
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        do {
            data = try encoder.encode(diaryModelWrapper)
        } catch {
            
        }
        return data
    }
    
    func dataConvertToManagedObjectContext(data: Data) {
        showActivity = true
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let diaryModelWrapper = try decoder.decode(DiaryModelWrapper.self, from: data)
            for diaryModel in diaryModelWrapper.diaries {
                let diary = Diary(context: viewContext)
                diary.title = diaryModel.title
                diary.content = diaryModel.content
                diary.mood = diaryModel.mood
                diary.weather = diaryModel.weather
                diary.mean = diaryModel.starred
                diary.lastModifiedTime = diaryModel.modifiedDate
                diary.date = diaryModel.createdDate
                try viewContext.save()
                print(diary)
            }
            showActivity = false
            
        } catch {
       
        }
        
        
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environment(\.locale, .init(identifier: "zh-CN"))
    }
}

struct SettingRowView: View {
    let color: Color
    let icon: String
    let settingName: String
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 25, height: 25)
                    .foregroundColor(color)
                Image(systemName: icon)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
            }
            Text(settingName)
        }
        
    }
}

struct ActivityViewController: UIViewControllerRepresentable {

    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}

}

