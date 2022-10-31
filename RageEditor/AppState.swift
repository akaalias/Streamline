//
//  AppState.swift
//  RageEditor
//
//  Created by Alexis Rondeau on 11.09.22.
//

import Foundation
import SwiftUI
import Combine
import SpriteKit

class AppState: ObservableObject {
    
    @Published var characters: [String] = []
    @Published var lastWord: [String] = []
    @Published var attributedString = AttributedString("")
    @Published var firstPartAttributedString = AttributedString("")
    @Published var lastWordAttributedString = AttributedString("")
    @Published var words: [String] = []
    @Published var currentlySearching = false
    @Published var allCharacters: [String]

    @Published var scene: ParticleScene
    @Published var secondsElapsed: Int = 0
    @Published var typingSpeed: Float = 0.0
    @Published var searchString: [String] = []
    @Published var selectedAutocompleteOption: String = ""
    @Published var selectIndex = -1
    @Published var defaultFontSize = 28.0
    @Published var ratioLeft = 0.6
    @Published var ratioRight = 0.4
    @Published var ratioTop = 2.25
    @Published var markdownFileNames: [String] = []
    
    @AppStorage("folderBookmarkData") private var folderBookmarkData: Data = Data()

    var timer: Timer?
    
    init() {
        allCharacters = []
        scene = ParticleScene()
        scene.scaleMode = .resizeFill
        scene.backgroundColor = .clear
    }
    
    func autocompleteSearchMatches() -> [String] {
        if(searchString.count <= 3) { return [] }
        let filteredFileNames = markdownFileNames.filter { $0.localizedCaseInsensitiveContains(searchString.joined()) }
        if(filteredFileNames.count >= 6) {
            return Array(filteredFileNames.prefix(upTo: 6))
        } else {
            return filteredFileNames
        }
    }
    
    func selectNextAutocompleteOptionsDown() {
        if(selectIndex < autocompleteSearchMatches().count - 1) {
            selectIndex += 1
            selectOption()
        }
    }

    func selectNextAutocompleteOptionsUp() {
        if(selectIndex >= 0) {
            selectIndex -= 1
            selectOption()
        }
    }
    
    func selectOption() {
        selectedAutocompleteOption = searchString.joined()

        if(selectIndex >= 0 && selectIndex < autocompleteSearchMatches().count) {
            selectedAutocompleteOption = autocompleteSearchMatches()[selectIndex]
        }
    }
    
    func resetSearch() {
        selectedAutocompleteOption = searchString.joined()
        selectIndex = -1
    }
    
    func cacheMarkdownFilenames(url: URL) {
        self.markdownFileNames = []
        if let enumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys: [.isRegularFileKey, .documentIdentifierKey, .contentTypeKey, .nameKey], options: [.skipsHiddenFiles, .skipsPackageDescendants]) {
            for case let fileURL as URL in enumerator {
                do {
                    let fileAttributes = try fileURL.resourceValues(forKeys:[.isRegularFileKey, .contentTypeKey])
                    if (fileAttributes.isRegularFile! && fileAttributes.contentType != nil) {
                        if(fileAttributes.contentType != nil && fileAttributes.contentType?.description == "net.daringfireball.markdown") {
                            let fileName = String(fileURL.lastPathComponent.dropLast(3))
                            self.markdownFileNames.append(fileName)
                        }
                    }
                } catch { print(error, fileURL) }
            }
        }

        self.markdownFileNames = Array(Set(self.markdownFileNames))
    }
    
    func updateTypingSpeed() {
        secondsElapsed += 1

        if(allCharacters.count > 0) {
            self.typingSpeed = Float(allCharacters.count) / Float(secondsElapsed)
        }
        
        let scale = CGFloat(0.4 * self.typingSpeed * Float.random(in: 0.1 ..< 1.0))

        self.scene.snowEmitterNode?.particleScale = scale
        self.scene.snowEmitterNode?.particleAlpha = CGFloat(self.typingSpeed / 100)
        self.scene.snowEmitterNode?.particleSpeed = CGFloat(-self.typingSpeed * 3)
        self.scene.snowEmitterNode?.xAcceleration = CGFloat(-self.typingSpeed * 3)
    }
    
    func handleKeyEvent(event: NSEvent) {
        let lastTypedCharacter = event.charactersIgnoringModifiers ?? ""
        if(self.currentlySearching) {
            if(event.characters == "\u{1B}") {
                // ESC = Optional("\u{1B}")
                self.currentlySearching = false
            } else if (event.keyCode == 51) {
                // Backspace
                self.searchString = self.searchString.dropLast()
                self.resetSearch()
            } else if (event.keyCode == 125 || event.keyCode == 48  ) {
                // Arrow DOWN
                self.selectNextAutocompleteOptionsDown()
            } else if (event.keyCode == 126) {
                // Arrow UP
                self.selectNextAutocompleteOptionsUp()
            } else if (event.keyCode == 36) {
                // Enter
                let appendString = self.selectedAutocompleteOption + "]] "
                self.selectedAutocompleteOption = ""

                let arrayLiteral = Array(arrayLiteral: appendString)
                self.allCharacters.append(contentsOf: arrayLiteral)
                self.characters.append(contentsOf: arrayLiteral)
                self.lastWord.append(contentsOf: arrayLiteral)
                self.currentlySearching = false

            } else {
                self.searchString.append(lastTypedCharacter)
                self.resetSearch()
            }
        } else {
            if(lastTypedCharacter == "[" && self.allCharacters.last == "[") {
                self.currentlySearching = true
                self.searchString = []
                self.lastWord = []
                self.lastWord.append("[")
            }
            
            self.allCharacters.append(lastTypedCharacter)
                
                if(lastTypedCharacter == " ") {
                    self.words.append(self.lastWord.joined())
                }
                
                if(event.keyCode == 36) {
                    self.characters.append("↩")
                    self.lastWord = []
                } else {
                    self.characters.append(lastTypedCharacter)
                    if(lastTypedCharacter == " ") {
                        self.lastWord = []
                    } else {
                        self.lastWord.append(lastTypedCharacter)
                    }
                }
        }
        
        self.firstPartAttributedString = AttributedString(self.characters.dropLast(self.lastWord.count).joined())
        self.firstPartAttributedString.foregroundColor = Color.gray
        self.lastWordAttributedString = AttributedString(self.lastWord.joined())
        self.lastWordAttributedString.foregroundColor = .white
        self.attributedString = AttributedString("")
        self.attributedString.append(self.firstPartAttributedString)
        self.attributedString.append(self.lastWordAttributedString)
    }

    
    @objc func fireTimer() {
        updateTypingSpeed()
    }

    func startTimer() {
        self.scene.snowEmitterNode?.particleScale = CGFloat(0.0)

        self.timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(fireTimer),
                                     userInfo: [ "foo" : "bar" ],
                                     repeats: true)
    }
}
