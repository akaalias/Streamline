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
                        .frame(width: 20, height: 64)
                        .opacity(opacity)
                        .onAppear() {
                            withAnimation(.easeInOut(duration: 2).repeatForever()) {
                                opacity = 0.2
                            }
                        }
                        .offset(x: -10)
            }
            
        }
        .onAppear() {
            NSEvent.addLocalMonitorForEvents(matching: .keyDown) { (event) -> NSEvent? in
                let character = event.charactersIgnoringModifiers ?? ""

                state.allCharacters.append(character)
                
                if(event.keyCode == 36) {
                    // Save it but not display it
                    characters = []
                    lastWord = []
                    attributedString = AttributedString("")

                } else {
                    
                    characters.append(character)
                    
                    if(character == " ") {
                        self.lastWord = []
                    } else {
                        self.lastWord.append(character)
                    }
                    
                    firstPartAttributedString = AttributedString(characters.dropLast(lastWord.count).joined())
                    firstPartAttributedString.foregroundColor = .gray
                    lastWordAttributedString = AttributedString(lastWord.joined())
                    lastWordAttributedString.foregroundColor = .white
                    attributedString = AttributedString("")
                    attributedString.append(firstPartAttributedString)
                    attributedString.append(lastWordAttributedString)
                    
                    if event.keyCode == 53 { // if esc pressed
                        return nil // do not do "beep" sound
                    }
                }
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

