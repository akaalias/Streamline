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
    @State private var resetRequested: Bool = false
    @State var refresh: Bool = false

    var body: some View {
        GeometryReader { geometry in
            if(folderBookmarkData.isEmpty) {
               FolderSetupView()
                .offset(x: geometry.size.width / 2.0 - 200,
                        y: (geometry.size.height / 2) - 200)
            } else {
                ZStack {
                    SpriteView(scene: state.scene, options: [.allowsTransparency])
                        .ignoresSafeArea()
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        .opacity(1)
                                   
                    RageTextInput()
                        .offset(y: (geometry.size.height / state.ratioTop) - state.defaultFontSize)
                    
                    Button() {
                        self.folderBookmarkData = Data()
                        self.update()
                    } label: {
                        Text("Reset")
                    }
                    .offset(x: geometry.size.width / 2 - 50, y: geometry.size.height / 2 - 30)
                    
                    Text(String(state.markdownFileNames.count))
                        .offset(x: geometry.size.width / 2 - 100, y: geometry.size.height / 2 - 30)
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
            
            // Begin particle system
            state.startTimer()
        }
    }
    
    func update() {
       refresh.toggle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
