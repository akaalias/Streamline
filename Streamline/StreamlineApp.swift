//
//  RageEditorApp.swift
//  RageEditor
//
//  Created by Alexis Rondeau on 24.08.22.
//

import SwiftUI

@main
struct StreamlineApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("showDemoVideo") private var showDemoVideo: Bool = true
    @StateObject var state = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(state)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
                        if let window = NSApplication.shared.windows.last {
                            window.toggleFullScreen(nil)
                        }
                    })
                }
        }
        .commands {
            CommandGroup(replacing: CommandGroupPlacement.newItem) {
                Button("Save as Markdown") {
                    save()
                }
                .keyboardShortcut("s", modifiers: [.command])
                
                Button("Reset") {
                    self.state.resetSessionData()
                }
                .keyboardShortcut("k", modifiers: [.command])
            }
            
            CommandGroup(replacing: CommandGroupPlacement.appSettings) {
                Button("Settings") {
                    state.showSettingsPanel = true
                }
            }
            
            CommandGroup(after: .help) {
                Button("Show Welcome Screen") {
                    state.showWelcomeScreen = true
                }
            }
        }
        .windowStyle(HiddenTitleBarWindowStyle())
    }
    
    func save() {
        let savePanel = NSSavePanel()
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YY"
        let dateString = formatter.string(from: date)

        savePanel.allowedFileTypes = ["md"]
        savePanel.canCreateDirectories = true
        savePanel.isExtensionHidden = false
        savePanel.allowsOtherFileTypes = false
        savePanel.title = "Save your Streamline Session as markdown"
        savePanel.message = "Choose a folder and a name"
        savePanel.prompt = "Save now"
        savePanel.nameFieldLabel = "File name:"
        savePanel.nameFieldStringValue = "Streamline Note " + dateString
        
        // Present the save panel as a modal window.
        let response = savePanel.runModal()
        guard response == .OK, let saveURL = savePanel.url else { return }
        try? self.state.allCharactersStorageStringArray.joined().write(to: saveURL, atomically: true, encoding: .utf8)
    }
}
