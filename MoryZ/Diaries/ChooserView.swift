//
//  ConfirmationDialogChooserView.swift
//  MoryZ
//
//  Created by 周源坤 on 2022/1/3.
//

import SwiftUI

struct ChooserView<T>: View where T: Identifiable, T: CustomStringConvertible {
    @Binding var showOption: Bool
    let currentOption: String
    let options: [T]
    let informativeText: String
    
    
    var action: (String) -> ()
    
//    init(showOption: Binding<Bool>, currentOption: String, options: [T], informativeText: String, action: @escaping (T) -> ()) {
//        self.showOption = showOption
//        self.currentOption = currentOption
//        self.informativeText = informativeText
//        self.options = options
//        self.action = action
//    }
    
    
    var body: some View {
        Button(action: {
            showOption = true
        }) {
            Text(currentOption)
                .font(.system(size: 40))
                .confirmationDialog(informativeText, isPresented: $showOption, titleVisibility: .visible) {
                    ForEach(options) { option in
                        Button(action: {action(String(describing: option))}) {
                            Text(String(describing: option))
                        }
                    }
                }
        }
    }
}

struct ChooserView_Previews: PreviewProvider {
    
    @State static var showOption = true
    
    static var previews: some View {
        ChooserView(showOption: $showOption, currentOption: "😄", options: Mood.allCases, informativeText: "How about the mood today ?", action: { mood in
            print(mood)
        })
    }
}
