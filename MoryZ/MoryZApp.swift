//
//  MoryZApp.swift
//  MoryZ
//
//  Created by 周源坤 on 2021/12/1.
//

import SwiftUI

@main
struct MoryZApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environment(\.locale, .init(identifier: "en"))
        }
    }
}
