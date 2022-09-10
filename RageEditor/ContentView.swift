//
//  ContentView.swift
//  RageEditor
//
//  Created by Alexis Rondeau on 24.08.22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var keyboardInput = KeyboardInput()

    var body: some View {
        KeyboardEvent(into: $keyboardInput.keyCode)
        Text("\(keyboardInput.keyCode)")
        RageTextInput()
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
            print(event.keyCode)
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
