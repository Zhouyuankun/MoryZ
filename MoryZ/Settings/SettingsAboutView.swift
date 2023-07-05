//
//  TestView.swift
//  MoryZ
//
//  Created by 周源坤 on 2022/1/3.
//

import SwiftUI

struct SettingsAboutView: View {
    @State var scale = false
    var body: some View {
        ZStack {
            Image("book")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .scaleEffect(scale ? 2 : 1)
                .animation(.spring(), value: scale)
                .shadow(radius: 10, x: 0, y: 10)
                .onTapGesture {
                    scale.toggle()
                }
            
         
                Text("Everything about you worth recording")
                    .offset(x: 0, y: -150)
                    .opacity(scale ? 1 : 0)
                    .animation(.easeInOut, value: scale)
        
            
            VStack {
                Spacer()
                Image("Z_icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                Text("Designed by")
                Text("Celeglow")
                    .bold()
                Text("All rights reserved to Celeglow")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
        }
        
            
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsAboutView()
    }
}
