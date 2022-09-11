//
//  RageEditorApp.swift
//  RageEditor
//
//  Created by Alexis Rondeau on 24.08.22.
//

import SwiftUI

@main
struct RageEditorApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var state = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(state)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
