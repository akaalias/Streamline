//
//  RageTextInput.swift
//  RageEditor
//
//  Created by Alexis Rondeau on 24.08.22.
//

import SwiftUI

struct RageTextInput: View {
    @State private var input: String = ""
    @State private var characters: [String] = []
    @State private var lastWord: [String] = []
    @State private var newWordHasStarted = true
    @State private var attributedString = AttributedString("")
    @State private var mostRecentSpaceIndex = 0
    @StateObject var keyboardInput = KeyboardInput()

    public init(displayMode: String) {
    }

    var body: some View {
        KeyboardEvent(into: $keyboardInput.keyCode)

        HStack {
            Text(attributedString)
                .font(.system(size: 64))
                .truncationMode(.head)
                .frame(width: 400, alignment: .trailing)
                .lineLimit(1)
                .foregroundColor(.gray)
                .mask(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .leading, endPoint: .trailing))
            
            TextField("", text: $input)
                .disableAutocorrection(true)
                .font(.system(size: 64))
                .frame(width: 10)
                .background(.white)
                .foregroundColor(.white)
                .onChange(of: input) { newValue in
                    if(input != "") {
                        characters.append(input)
                                                
                        if(input == " ") {
                            self.lastWord = []
                        } else { self.lastWord.append(input) }
                        
                        var firstPartAttributedString = AttributedString(characters.dropLast(lastWord.count).joined())
                        firstPartAttributedString.foregroundColor = .gray

                        var lastWordAttributedString = AttributedString(lastWord.joined())
                        lastWordAttributedString.foregroundColor = .white
                        
                        var final = AttributedString("")
                        final.append(firstPartAttributedString)
                        final.append(lastWordAttributedString)
                        
                        self.attributedString = final
                        
                        input = ""
                    }
                }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        }
}

struct RageTextInput_Previews: PreviewProvider {
    static var previews: some View {
        RageTextInput(displayMode: "Character")
    }
}

// Hides blue focus glow
extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
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


extension String {
    func rangeFromNSRange(nsRange : NSRange) -> Range<String.Index>? {
        return Range(nsRange, in: self)
    }
}
