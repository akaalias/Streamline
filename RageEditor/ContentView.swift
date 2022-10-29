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
    @State var showFileChooser = false

    var body: some View {
        GeometryReader { geometry in
            if(folderBookmarkData.isEmpty) {
                
                ZStack {
                    RoundedRectangle(cornerSize: CGSize(width: 10.0, height: 10.0))
                        .foregroundColor(.black.opacity(0.2))
                        .frame(width: 400, height: 400)

                    VStack {
                        Text("Please Configure Your Folder")
                            .font(.largeTitle)
                        Button {
                            setupFolder()
                        } label: {
                            Text("Select Folder")
                        }
                        .buttonStyle(.bordered)
                    }

                }
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
                }

            }
        }
        .onAppear() {
            // App is ready
            state.startTimer()
            
            // self.folderBookmarkData = Data()
            
            // Bookmark handling
            if(!self.folderBookmarkData.isEmpty) {
                do {
                    var isStale = false

                    let newURL = try URL(resolvingBookmarkData: self.folderBookmarkData, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
                    
                    newURL.startAccessingSecurityScopedResource()
                    self.cacheMarkdownFilenames(url: newURL)
                    newURL.stopAccessingSecurityScopedResource()

                } catch {
                    print("Error while decoding bookmark URL data")
                }
            }
        }
    }
    
    func setupFolder() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = true
        panel.canChooseFiles = false

        if panel.runModal() == .OK {
            
            let url = panel.url
            do {
                let bookmarkData = try url?.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
                
                self.folderBookmarkData = bookmarkData!

                cacheMarkdownFilenames(url: url!)

            } catch {
                print("Error while accessing folder!")
            }
        }
    }
    
    func cacheMarkdownFilenames(url: URL) {
        print("Caching for: " + url.absoluteString)
        if let enumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys: [.isRegularFileKey, .documentIdentifierKey, .contentTypeKey, .nameKey], options: [.skipsHiddenFiles, .skipsPackageDescendants]) {
            for case let fileURL as URL in enumerator {
                do {
                    let fileAttributes = try fileURL.resourceValues(forKeys:[.isRegularFileKey, .contentTypeKey])
                    if (fileAttributes.isRegularFile! && fileAttributes.contentType != nil) {
                        if(fileAttributes.contentType != nil && fileAttributes.contentType?.description == "net.daringfireball.markdown") {
                            let fileName = String(fileURL.lastPathComponent.dropLast(3))
                            state.markdownFileNames.append(fileName)
                            // print(fileName)
                        }
                    }
                } catch { print(error, fileURL) }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class KeyboardInput: ObservableObject {
    @Published var keyCode: UInt16 = 0
}

struct KeyboardEvent: NSViewRepresentable {
    @Binding var keyStorage: UInt16          // << here !!
    init(into storage: Binding<UInt16>) {
        _keyStorage = storage
    }

    class KeyView: NSView {
        var owner: KeyboardEvent?   // << view holder
        override var acceptsFirstResponder: Bool { true }
        override func keyDown(with event: NSEvent) {
            owner?.keyStorage = event.keyCode
        }
    }

    func makeNSView(context: Context) -> NSView {
        let view = KeyView()
        view.owner = self           // << inject
        DispatchQueue.main.async {
            view.window?.makeFirstResponder(view)
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
    }
}
