//
//  RageTextInput.swift
//  RageEditor
//
//  Created by Alexis Rondeau on 24.08.22.
//

import SwiftUI
import SwiftUIX

struct RageTextInput: View {
    @EnvironmentObject var state: AppState

    @State private var characters: [String] = []
    @State private var lastWord: [String] = []
    @State private var attributedString = AttributedString("")
    @State private var firstPartAttributedString = AttributedString("")
    @State private var lastWordAttributedString = AttributedString("")
    @State private var opacity = 1.0
    @State private var words: [String] = []
    @State private var currentlySearching = false
    @State private var searchString: [String] = []

    @StateObject var keyboardInput = KeyboardInput()

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

                    Rectangle()
                        .fill(.white)
                        .frame(width: 15, height: 108)
                        .opacity(opacity)
                        .onAppear() {
                            withAnimation(.easeInOut(duration: 2).repeatForever()) {
                                opacity = 0.2
                            }
                        }
                        .offset(x: -8)
                    
                    // Autocomplete
                    AutocompleteView()
                        .visible(currentlySearching)

                }
            
        }
        .onAppear() {
            NSEvent.addLocalMonitorForEvents(matching: .keyDown) { (event) -> NSEvent? in

                let lastTypedCharacter = event.charactersIgnoringModifiers ?? ""
                
                if(currentlySearching) {
                    
                    print(event.keyCode)
                    
                    if(event.keyCode == 48) {
                        // TAB
                        currentlySearching = false
                    } else if (event.keyCode == 51) {
                        // Backspace
                        state.searchString = state.searchString.dropLast()
                    } else if (event.keyCode == 125) {
                        // Arrow DOWN
                        state.selectNextAutocompleteOptionsDown()
                    } else if (event.keyCode == 126) {
                        // Arrow UP
                        state.selectNextAutocompleteOptionsUp()
                    } else if (event.keyCode == 36) {
                        // Enter
                        let appendString = state.selectedAutocompleteOption + "]]"
                        state.selectedAutocompleteOption = ""

                        let arrayLiteral = Array(arrayLiteral: appendString)
                        state.allCharacters.append(contentsOf: arrayLiteral)
                        characters.append(contentsOf: arrayLiteral)
                        self.lastWord.append(contentsOf: arrayLiteral)

                        currentlySearching = false
                    } else {
                        state.searchString.append(lastTypedCharacter)
                        state.selectedAutocompleteOption = state.searchString.joined()
                    }

                } else {

                    if(lastTypedCharacter == "[" && state.allCharacters.last == "[") {
                        currentlySearching = true
                        state.searchString = []
                        self.lastWord = []
                        self.lastWord.append("[")
                    }
                    
                    
                    state.allCharacters.append(lastTypedCharacter)
                        
                        if(lastTypedCharacter == " ") {
                            self.words.append(self.lastWord.joined())
                        }
                        
                        if(event.keyCode == 36) {
                            characters.append("↩")
                            self.lastWord = []
                        } else {
                            characters.append(lastTypedCharacter)
                            if(lastTypedCharacter == " ") {
                                self.lastWord = []
                            } else {
                                self.lastWord.append(lastTypedCharacter)
                            }
                        }
                }
                
                firstPartAttributedString = AttributedString(characters.dropLast(lastWord.count).joined())
                firstPartAttributedString.foregroundColor = .gray
                lastWordAttributedString = AttributedString(lastWord.joined())
                lastWordAttributedString.foregroundColor = .white
                attributedString = AttributedString("")
                attributedString.append(firstPartAttributedString)
                attributedString.append(lastWordAttributedString)
                
                // state.scene.emitOne()

                return event
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

