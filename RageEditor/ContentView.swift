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

    @State var autocompleteFileFolder = ""
    @State var showFileChooser = false

    var body: some View {
        
        GeometryReader { geometry in
            VStack {
                Button("Select Folder")
                      {
                        let panel = NSOpenPanel()
                        panel.allowsMultipleSelection = false
                        panel.canChooseDirectories = true
                          panel.canChooseFiles = false
                        if panel.runModal() == .OK {
                            self.autocompleteFileFolder = panel.url?.absoluteString ?? "<none>"

                            let url = panel.url!
                            if let enumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys: [.isRegularFileKey, .documentIdentifierKey, .contentTypeKey, .nameKey], options: [.skipsHiddenFiles, .skipsPackageDescendants]) {
                                for case let fileURL as URL in enumerator {
                                    do {
                                        let fileAttributes = try fileURL.resourceValues(forKeys:[.isRegularFileKey, .contentTypeKey])
                                        if (fileAttributes.isRegularFile! && fileAttributes.contentType != nil) {
                                            if(fileAttributes.contentType != nil && fileAttributes.contentType?.description == "net.daringfireball.markdown") {

                                                let fileName = String(fileURL.lastPathComponent.dropLast(3))
                                                state.markdownFileNames.append(fileName)
                                            }
                                        }
                                    } catch { print(error, fileURL) }
                                }
                            }
                        }
                      }
                ZStack {
                    Path() { path in
                        path.move(to: CGPoint(x: geometry.size.width * state.ratioLeft, y: -30))
                        path.addLine(to: CGPoint(x: geometry.size.width * state.ratioLeft, y: geometry.size.height))
                    }
                    .stroke(.white, lineWidth: 1)
                    .opacity(0.1)

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
            state.startTimer()
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
