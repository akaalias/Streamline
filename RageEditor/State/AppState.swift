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
    
    @Published var visibleCharactersStringArray: [String] = []
    @Published var visibleLastWordStringArray: [String] = []
    @Published var attributedString = AttributedString("")
    @Published var firstPartAttributedString = AttributedString("")
    @Published var lastWordAttributedString = AttributedString("")
    @Published var currentlySearching = false
    @Published var allCharactersStorageStringArray: [String]

    @Published var scene: ParticleScene
    @Published var secondsElapsed: Int = 0
    @Published var typingSpeed: Float = 0.0
    @Published var searchStringArray: [String] = []
    @Published var selectedAutocompleteOption: String = ""
    @Published var selectIndex = -1
    @Published var defaultFontSize = 38.0
    @Published var ratioLeft = 0.6
    @Published var ratioRight = 0.4
    @Published var ratioTop = 2.25
    @Published var markdownFileNames: [String] = []
    
    @AppStorage("folderBookmarkData") private var folderBookmarkData: Data = Data()

    var timer: Timer?
    
    init() {
        allCharactersStorageStringArray = []
        scene = ParticleScene()
        scene.scaleMode = .resizeFill
        scene.backgroundColor = .clear
    }
    
    func autocompleteSearchMatches() -> [String] {
        if(searchStringArray.count <= 3) { return [] }
        let filteredFileNames = markdownFileNames.filter { $0.localizedCaseInsensitiveContains(searchStringArray.joined()) }
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
        selectedAutocompleteOption = searchStringArray.joined()

        if(selectIndex >= 0 && selectIndex < autocompleteSearchMatches().count) {
            selectedAutocompleteOption = autocompleteSearchMatches()[selectIndex]
        }
    }
    
    func resetSearch() {
        selectedAutocompleteOption = searchStringArray.joined()
        selectIndex = -1
    }
    
    func setupCacheFromBookmark() {
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
        
    func handleKeyEvent(event: NSEvent) {
        let lastTypedCharacterIgnoringModifiers = event.charactersIgnoringModifiers ?? ""
        let lastTypedCharacters = event.characters ?? ""
        let charactersWithModifiersApplied = event.characters(byApplyingModifiers: event.modifierFlags) ?? ""
        let modifierFlags = event.modifierFlags
        
        //        print("lastTypedCharacterIgnoringModifiers: " + lastTypedCharacterIgnoringModifiers)
        //        print("lastTypedCharacter: " + lastTypedCharacters)
        //        print("charactersWithModifiersApplied: " + charactersWithModifiersApplied)
        //        print("modifierFlags: " + modifierFlags.rawValue.description)
        
        // Autocomplete triggered
        if(self.currentlySearching) {
            if(event.characters == "\u{1B}") {
                // ESC = Optional("\u{1B}")
                self.currentlySearching = false
            } else if (event.keyCode == 51) {
                // Backspace
                self.searchStringArray = self.searchStringArray.dropLast()
                self.resetSearch()
            } else if (event.keyCode == 125 || event.keyCode == 48  ) {
                // Arrow DOWN
                self.selectNextAutocompleteOptionsDown()
            } else if (event.keyCode == 126) {
                // Arrow UP
                self.selectNextAutocompleteOptionsUp()
            } else if (event.keyCode == 36) {
                var appendString = self.selectedAutocompleteOption

                // Enter
                if(!self.selectedAutocompleteOption.reversed().starts(with: "]]")) {
                    appendString = appendString + "]]"
                }
                self.selectedAutocompleteOption = ""

                let arrayLiteral = Array(arrayLiteral: appendString)
                self.allCharactersStorageStringArray.append(contentsOf: arrayLiteral)
                self.visibleCharactersStringArray.append(contentsOf: arrayLiteral)
                self.visibleLastWordStringArray.append(contentsOf: arrayLiteral)
                self.currentlySearching = false
            } else {
                self.searchStringArray.append(lastTypedCharacterIgnoringModifiers)
                self.resetSearch()
            }
        } else {
            if(lastTypedCharacterIgnoringModifiers == "[" && self.allCharactersStorageStringArray.last == "[") {
                self.currentlySearching = true
                self.searchStringArray = []
                self.visibleLastWordStringArray = []
                self.visibleLastWordStringArray.append("[")
            }
            
            self.allCharactersStorageStringArray.append(lastTypedCharacterIgnoringModifiers)
                if(lastTypedCharacterIgnoringModifiers == " ") {
                }
                
                if(event.keyCode == 36) {
                    self.visibleCharactersStringArray.append("¶")
                    self.visibleLastWordStringArray = []
                } else {
                    self.visibleCharactersStringArray.append(lastTypedCharacterIgnoringModifiers)
                    if(lastTypedCharacterIgnoringModifiers == " ") {
                        self.visibleLastWordStringArray = []
                    } else {
                        self.visibleLastWordStringArray.append(lastTypedCharacterIgnoringModifiers)
                    }
                }
        }
        
        self.firstPartAttributedString = AttributedString(self.visibleCharactersStringArray.dropLast(self.visibleLastWordStringArray.count).joined())
        self.firstPartAttributedString.foregroundColor = Color.gray
        self.lastWordAttributedString = AttributedString(self.visibleLastWordStringArray.joined())

        if(self.visibleLastWordStringArray.joined().starts(with: "[[")) {
            self.lastWordAttributedString.foregroundColor = Color("ObsidianPurple")
        } else {
            self.lastWordAttributedString.foregroundColor = .white
        }

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

    func updateTypingSpeed() {
        secondsElapsed += 1

        if(allCharactersStorageStringArray.count > 0) {
            self.typingSpeed = Float(allCharactersStorageStringArray.count) / Float(secondsElapsed)
        }
        
        let scale = CGFloat(0.4 * self.typingSpeed * Float.random(in: 0.1 ..< 1.0))

        self.scene.snowEmitterNode?.particleScale = scale
        self.scene.snowEmitterNode?.particleAlpha = CGFloat(self.typingSpeed / 100)
        self.scene.snowEmitterNode?.particleSpeed = CGFloat(-self.typingSpeed * 3)
        self.scene.snowEmitterNode?.xAcceleration = CGFloat(-self.typingSpeed * 3)
    }
}
