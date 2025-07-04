//
//  ThinkFirstApp.swift
//  ThinkFirst
//
//  Created by Shahdad Neda on 2025-07-03.
//

import SwiftUI

@main
struct ThinkFirstApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
