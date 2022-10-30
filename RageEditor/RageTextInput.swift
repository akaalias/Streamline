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

    public static var viewAppearedCount: Int = 0

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
    @State private var monitor: Any?

    var body: some View {
        KeyboardEvent(into: $keyboardInput.keyCode)

        GeometryReader { geometry in
                Path() { path in
                    path.move(to: CGPoint(x: 0, y: state.defaultFontSize * 1.5))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: state.defaultFontSize * 1.5))
                }
                .stroke(.white, lineWidth: 1)
                .opacity(0.1)

                HStack {
                    Text(attributedString)
                        .font(.system(size: state.defaultFontSize))
                        .truncationMode(.head)
                        .lineLimit(1)
                        .foregroundColor(.gray)
                        .frame(width: geometry.size.width * state.ratioLeft, alignment: .trailing)
                        .mask(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .leading, endPoint: .trailing))
                        .offset(x: -15)

                    Rectangle()
                        .fill(.white)
                        .frame(width: 15, height: state.defaultFontSize * 1.5)
                        .opacity(opacity)
                        .onAppear() {
                            withAnimation(.easeInOut(duration: 2).repeatForever()) {
                                opacity = 0.2
                            }
                        }
                        .offset(x: -23)
                }

            // Autocomplete
            AutocompleteView()
                .visible(currentlySearching)
                .offset(x: geometry.size.width * state.ratioLeft)

        }
        .onDisappear() {
            NSEvent.removeMonitor(self.monitor)
        }
        .onAppear() {
            self.monitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { (aEvent) -> NSEvent? in
                self.handleKeyEvent(event: aEvent)
                return aEvent
            }
        }
    }
    
    func handleKeyEvent(event: NSEvent) {
        
        let lastTypedCharacter = event.charactersIgnoringModifiers ?? ""
        
        // ESC = Optional("\u{1B}")
        if(currentlySearching) {
            if(event.keyCode == 48) {
                // TAB
                currentlySearching = false
            } else if (event.keyCode == 51) {
                // Backspace
                state.searchString = state.searchString.dropLast()
                state.resetSearch()
            } else if (event.keyCode == 125) {
                // Arrow DOWN
                state.selectNextAutocompleteOptionsDown()
            } else if (event.keyCode == 126) {
                // Arrow UP
                state.selectNextAutocompleteOptionsUp()
            } else if (event.keyCode == 36) {
                // Enter
                let appendString = state.selectedAutocompleteOption + "]] "
                state.selectedAutocompleteOption = ""

                let arrayLiteral = Array(arrayLiteral: appendString)
                state.allCharacters.append(contentsOf: arrayLiteral)
                characters.append(contentsOf: arrayLiteral)
                self.lastWord.append(contentsOf: arrayLiteral)

                currentlySearching = false
            } else {
                state.searchString.append(lastTypedCharacter)
                state.resetSearch()
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
        
        return
    }
}

struct RageTextInput_Previews: PreviewProvider {
    static var previews: some View {
        RageTextInput()
    }
}
