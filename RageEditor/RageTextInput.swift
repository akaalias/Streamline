//
//  RageTextInput.swift
//  RageEditor
//
//  Created by Alexis Rondeau on 24.08.22.
//

import SwiftUI
import SwiftUIX


struct RageTextInput: View {
    private enum Field: Int, Hashable {
            case inputField
    }

    @State private var input: String = ""
    @State private var characters: [String] = []
    @State private var lastWord: [String] = []
    @State private var attributedString = AttributedString("")
    @State private var firstPartAttributedString = AttributedString("")
    @State private var lastWordAttributedString = AttributedString("")
    @State private var opacity = 1.0
    @StateObject var keyboardInput = KeyboardInput()
    @FocusState private var focusedField: Field?

    var body: some View {
        KeyboardEvent(into: $keyboardInput.keyCode)

        GeometryReader { geometry in
            HStack {
                Text(attributedString)
                    .font(.system(size: 64))
                    .truncationMode(.head)
                    .lineLimit(1)
                    .foregroundColor(.gray)
                    .frame(width: geometry.size.width * 0.6, alignment: .trailing)
                    .mask(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .leading, endPoint: .trailing))
                    .offset(y: (geometry.size.height / 2) * -0.5 )

                TextField("", text: $input)
                    .disableAutocorrection(true)
                    .font(.system(size: 64))
                    .padding(10)
                    .background(.white)
                    .foregroundColor(.white)
                    .opacity(opacity)
                    .focused($focusedField, equals: .inputField)
                    .task {
                        self.focusedField = .inputField
                    }
                    .onAppear() {
                        withAnimation(.easeInOut(duration: 2).repeatForever()) {
                            opacity = 0.2
                        }
                    }
                    .onChange(of: input) { newValue in
                        if(input != "") {
                            characters.append(input)
                            
                            // Keep track of last word
                            if(input == " ") {
                                self.lastWord = []
                            } else { self.lastWord.append(input) }
                            
                            // update display strings
                            firstPartAttributedString = AttributedString(characters.dropLast(lastWord.count).joined())
                            firstPartAttributedString.foregroundColor = .gray
                            lastWordAttributedString = AttributedString(lastWord.joined())
                            lastWordAttributedString.foregroundColor = .white
                            attributedString = AttributedString("")
                            attributedString.append(firstPartAttributedString)
                            attributedString.append(lastWordAttributedString)
                            
                            input = ""
                        }
                    }
                    .frame(width: 10)
                    .offset(y: (geometry.size.height / 2) * -0.5 )

            }
        }
    }
}

struct RageTextInput_Previews: PreviewProvider {
    static var previews: some View {
        RageTextInput()
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
