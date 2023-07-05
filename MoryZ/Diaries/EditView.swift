//
//  EditView.swift
//  MoryZ
//
//  Created by 周源坤 on 2021/12/1.
//

import SwiftUI

struct EditView: View {
    @ObservedObject var diary: Diary
    @State var showAlert = false
    @State var text: String = ""
    @State var showWeatherOption = false
    @State var showMoodOption = false
    @State var showMeanOption = false
    @FocusState var focused: Bool?
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        if diary.weather != nil && diary.content != nil {
            ScrollView {
                VStack(spacing: 30) {
                    HStack(spacing: 80) {
                        ChooserView(showOption: $showWeatherOption, currentOption: diary.weather!, options: Weather.allCases, informativeText: "How about the weather today ?", action: { weather in
                            diary.weather = weather
                            try! viewContext.save()
                        })
                        ChooserView(showOption: $showMoodOption, currentOption: diary.mood!, options: Mood.allCases, informativeText: "How about the mood today ?", action: { mood in
                            diary.mood = mood
                            try! viewContext.save()
                        })
                        
                        ChooserView(showOption: $showMeanOption, currentOption: diary.mean!, options: Mean.allCases, informativeText: "Is today meaningful ?", action: { mean in
                            diary.mean = mean
                            try! viewContext.save()
                        })
                    }
                    VStack {
                        Text("\(monthFromNumToString(month: getMonth(date: diary.date!)))")
                            .font(.title)
                            .padding(10)
                        .frame(alignment: .leading)
                        Text("\(getDay(date: diary.date!))")
                            .font(.largeTitle)
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.6))
                    .shadow(color: Color.blue.opacity(0.6), radius: 3, x: 0, y: 10)
                  
                    Button(action: {
                        showAlert = true
                    }) {
                        Text(diary.title!)
                            .font(.largeTitle)
                            .bold()
                            .cornerRadius(10)
                            .lineLimit(1)
                    }
                    
                        .textFieldAlert(isPresented: $showAlert, title: "Title for this diary", action: { titleText in
                            guard let titleText = titleText else {
                                return
                            }
                            diary.title = titleText
                            diary.lastModifiedTime = Date()
                        })
                        TextEditor(text: Binding(get: {self.diary.content!}, set: {self.diary.content = $0}))
                                .focused($focused, equals: true)
                                .frame(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height / 2)
                                .padding()
                                .onChange(of: diary.content, perform: { _ in
                                    try! viewContext.save()
                                })
                
                    
                }
                    
            
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button(action: {
                            focused = nil
                            diary.lastModifiedTime = Date()
                        }) {
                            Text("Done")
                        }
                    }

                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(weekdayFromNumToString(weekday: getWeekday(date: diary.date!)))
            }
        }
        else {
            EmptyView()
        }
        
    }
}

public struct TextFieldAlertModifier: ViewModifier {

    @State private var alertController: UIAlertController?

    @Binding var isPresented: Bool

    let title: String
    let text: String
    let placeholder: String
    let action: (String?) -> Void

    public func body(content: Content) -> some View {
        content.onChange(of: isPresented) { isPresented in
            if isPresented, alertController == nil {
                let alertController = makeAlertController()
                self.alertController = alertController
               // UIApplication.shared.windows.first?.rootViewController?.present(alertController, animated: true)
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first else {
                    return
                }
                window.rootViewController?.present(alertController, animated: true)
            } else if !isPresented, let alertController = alertController {
                alertController.dismiss(animated: true)
                self.alertController = nil
            }
        }
    }

    private func makeAlertController() -> UIAlertController {
        let controller = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        controller.addTextField {
            $0.placeholder = self.placeholder
            $0.text = self.text
        }
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.action(nil)
            shutdown()
        })
        controller.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.action(controller.textFields?.first?.text)
            shutdown()
        })
        return controller
    }

    private func shutdown() {
        isPresented = false
        alertController = nil
    }

}
            
extension View {

    public func textFieldAlert(
        isPresented: Binding<Bool>,
        title: String,
        text: String = "",
        placeholder: String = "",
        action: @escaping (String?) -> Void
    ) -> some View {
        self.modifier(TextFieldAlertModifier(isPresented: isPresented, title: title, text: text, placeholder: placeholder, action: action))
    }
    
}

