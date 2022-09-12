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

    var body: some View {
        ZStack {
            SpriteView(scene: state.scene, options: [.allowsTransparency])
                .ignoresSafeArea()
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            
            GeometryReader { geometry in
                HStack {
                    Rectangle()
                        .frame(width: geometry.size.width * 0.6, alignment: .trailing)
                        .opacity(0.0)
                    
                    Rectangle()
                        .frame(width: geometry.size.width * 0.4, alignment: .trailing)
                        .opacity(0.1)
                }
                
                RageTextInput()
                    .offset(y: (geometry.size.height / 2.0) - 38.0)
            }
        }
        // Text("\(state.allCharacters.joined())")

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
            // print(event.keyCode)
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
