//
//  RageEditorApp.swift
//  RageEditor
//
//  Created by Alexis Rondeau on 24.08.22.
//

import SwiftUI

@main
struct RageEditorApp: App {
    @StateObject var state = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(state)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}
