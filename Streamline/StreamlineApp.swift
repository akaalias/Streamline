//
//  RageEditorApp.swift
//  RageEditor
//
//  Created by Alexis Rondeau on 24.08.22.
//

import SwiftUI

@main
struct StreamlineApp: App {
    @StateObject var state = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(state)
        }
        .commands {
            CommandGroup(replacing: CommandGroupPlacement.newItem) {
                Button("Save as Markdown") {
                    save()
                }
                .keyboardShortcut("s", modifiers: [.command])
            }
        }
        .windowStyle(HiddenTitleBarWindowStyle())
    }
    
    func save() {
        let savePanel = NSSavePanel()
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "YY/MM/dd-HH:mm"
        let dateString = formatter.string(from: date)

        savePanel.allowedFileTypes = ["md"]
        savePanel.canCreateDirectories = true
        savePanel.isExtensionHidden = false
        savePanel.allowsOtherFileTypes = false
        savePanel.title = "Save your Streamline note"
        savePanel.message = "Choose a folder and a name"
        savePanel.prompt = "Save now"
        savePanel.nameFieldLabel = "File name:"
        savePanel.nameFieldStringValue = "Streamline Note " + dateString
        
        // Present the save panel as a modal window.
        let response = savePanel.runModal()
        guard response == .OK, let saveURL = savePanel.url else { return }
        try? self.state.allCharactersStorageStringArray.joined().write(to: saveURL, atomically: true, encoding: .utf8)
        self.state.reset()
        
    }
}
