//
//  ContentView.swift
//  RageEditor
//
//  Created by Alexis Rondeau on 24.08.22.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @EnvironmentObject var state: AppState
    @AppStorage("folderBookmarkData") private var folderBookmarkData: Data = Data()
    @State var refresh: Bool = false

    var body: some View {
        GeometryReader { geometry in
            if(folderBookmarkData.isEmpty) {
               FolderSetupView()
                .offset(x: geometry.size.width / 2.0 - 200,
                        y: (geometry.size.height / 2) - 200)
            } else {
                ZStack {
                    RageTextInput()
                        .offset(y: (geometry.size.height / state.ratioTop) - state.defaultFontSize)
                }
            }
        }
        .onAppear() {
            // Bookmark handling
            if(!self.folderBookmarkData.isEmpty) {
                do {
                    var isStale = false
                    let newURL = try URL(resolvingBookmarkData: self.folderBookmarkData, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
                    newURL.startAccessingSecurityScopedResource()
                    state.cacheMarkdownFilenames(url: newURL)
                    newURL.stopAccessingSecurityScopedResource()
                } catch {
                    print("Error while decoding bookmark URL data")
                }
            }
        }
    }
    
    func update() {
       refresh.toggle()
    }
    
    func save() {
        let savePanel = NSSavePanel()
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "YY/MM/dd – HH:mm"
        let dateString = formatter.string(from: date)
        print(dateString)

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
        try? state.allCharacters.joined().write(to: saveURL, atomically: true, encoding: .utf8)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
