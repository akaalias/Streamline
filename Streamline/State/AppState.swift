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
    @Published var allCharactersStorageStringArray: [String]
    
    // Autocomplete
    @Published var currentlySearching = false
    @Published var searchStringArray: [String] = []
    @Published var selectedAutocompleteOption: String = ""
    @Published var selectIndex = -1
    @Published var markdownFileNames: [String] = []

    // Layout
    @Published var defaultFontSize = 38.0
    @Published var ratioLeft = 0.6
    @Published var ratioRight = 0.4
    @Published var ratioTop = 2.25
    @Published var folderConfigFrameSize = 400.0
    @Published var dynamicWindowSize = CGSize()
    @Published var fontSizeFactor = 20.0
    
    // Umlaute
    @Published var umlautModifierTyped = false
    
    // Settings
    @Published var showSettingsPanel = false
    
    // Particles
    @Published var scene: ParticleScene
    var timer: Timer?
    @Published var secondsElapsed: Int = 0
        
    @AppStorage("folderBookmarkData") private var folderBookmarkData: Data = Data()
    @AppStorage("vaultURL") private var vaultURL: URL?
    @AppStorage("logStorage") private var logStorage: String = ""
    @AppStorage("showWelcomeScreen") public var showWelcomeScreen: Bool = true

    init() {
        allCharactersStorageStringArray = []
        scene = ParticleScene()
        scene.scaleMode = .resizeFill
        scene.backgroundColor = .clear
        scene.state = self
    }
    
    func calculatedFontSize() -> CGFloat {
        return self.dynamicWindowSize.height / fontSizeFactor
    }
    
    func resetSessionData() {
        allCharactersStorageStringArray = []
        visibleCharactersStringArray = []
        visibleLastWordStringArray = []
        attributedString = AttributedString("")
    }
    
    func resetEverything() {
        resetSearch()
        resetSessionData()
        
        // Settings
        markdownFileNames = []
        folderBookmarkData = Data()
        vaultURL = URL(fileURLWithPath: "~")
        showWelcomeScreen = true
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

                if isStale {
                    logStorage += " | bookmark is stale."
                }

                if !newURL.startAccessingSecurityScopedResource() {
                    logStorage += " |  startAccessingSecurityScopedResource returned false."
                }

                self.cacheMarkdownFilenames(url: newURL)

                newURL.stopAccessingSecurityScopedResource()
            } catch {
                logStorage += " | Error while decoding bookmark URL data"
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
                        if(fileAttributes.contentType != nil) {
                            if(String(fileURL.lastPathComponent).reversed().starts(with: "dm.")) {
                                let fileName = String(fileURL.lastPathComponent.dropLast(3))
                                self.markdownFileNames.append(fileName)
                            }
                        }
                    }
                } catch {
                    logStorage += " | Error \(error) while caching \(fileURL.absoluteString)"
                }
            }
        }
        
        self.markdownFileNames = Array(Set(self.markdownFileNames))
    }
    
    func handleKeyEvent(event: NSEvent) -> NSEvent {
        var lastTypedCharacterIgnoringModifiers = event.charactersIgnoringModifiers ?? ""
        let _ = event.characters ?? ""
        let _ = event.characters(byApplyingModifiers: event.modifierFlags) ?? ""
        let modifierFlags = event.modifierFlags
                
        if(modifierFlags.contains(.command)) {
            // Ignore Command-[...]
            return event
        }
        
        if(modifierFlags.contains(.option) && lastTypedCharacterIgnoringModifiers == "u") {
            self.umlautModifierTyped = true
            return event
        }
        
        // Autocomplete triggered
        if(self.currentlySearching) {
            if(event.characters == "\u{1B}") {
                // ESC = Optional("\u{1B}")
                let appendString = "]]"
                self.selectedAutocompleteOption = ""
                let arrayLiteral = Array(arrayLiteral: appendString)
                self.allCharactersStorageStringArray.append(contentsOf: arrayLiteral)
                self.visibleCharactersStringArray.append(contentsOf: arrayLiteral)
                self.visibleLastWordStringArray.append(contentsOf: arrayLiteral)
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
            // Character input / Normal writing
            if(lastTypedCharacterIgnoringModifiers == "[" && self.allCharactersStorageStringArray.last == "[") {
                self.currentlySearching = true
                self.searchStringArray = []
                self.visibleLastWordStringArray = []
                self.visibleLastWordStringArray.append("[")
            }
            
            // Umlaute
            if(self.umlautModifierTyped) {
                if(lastTypedCharacterIgnoringModifiers == "a") {
                    lastTypedCharacterIgnoringModifiers = "??"
                }
                if(modifierFlags.contains(.shift) && lastTypedCharacterIgnoringModifiers == "A") {
                    lastTypedCharacterIgnoringModifiers = "??"
                }
                
                if(lastTypedCharacterIgnoringModifiers == "o") {
                    lastTypedCharacterIgnoringModifiers = "??"
                }
                if(modifierFlags.contains(.shift) && lastTypedCharacterIgnoringModifiers == "O") {
                    lastTypedCharacterIgnoringModifiers = "??"
                }
                
                if(lastTypedCharacterIgnoringModifiers == "u") {
                    lastTypedCharacterIgnoringModifiers = "??"
                }
                if(modifierFlags.contains(.shift) && lastTypedCharacterIgnoringModifiers == "U") {
                    lastTypedCharacterIgnoringModifiers = "??"
                }
                
                self.umlautModifierTyped = false
            }
                        
            if(event.keyCode == 36 || event.keyCode == 51) {
                // Acknowledge enter and backspace without deleting
                // TBD: Add TAB
                self.scene.emitOne()
                return event
            } else {
                // Store and display all others
                self.allCharactersStorageStringArray.append(lastTypedCharacterIgnoringModifiers)
                self.visibleCharactersStringArray.append(lastTypedCharacterIgnoringModifiers)
                if(lastTypedCharacterIgnoringModifiers == " ") {
                    self.visibleLastWordStringArray = []
                } else {
                    self.visibleLastWordStringArray.append(lastTypedCharacterIgnoringModifiers)
                }
            }
        }
        
        self.firstPartAttributedString = AttributedString(self.visibleCharactersStringArray.dropLast(self.visibleLastWordStringArray.count).joined())
        self.firstPartAttributedString.foregroundColor = Color("TextColor")
        self.lastWordAttributedString = AttributedString(self.visibleLastWordStringArray.joined())
        
        if(self.visibleLastWordStringArray.joined().starts(with: "[[")) {
            self.lastWordAttributedString.foregroundColor = Color("ObsidianPurple")
        } else {
            self.lastWordAttributedString.foregroundColor = Color("FirstWordColor")
        }
        
        self.attributedString = AttributedString("")
        self.attributedString.append(self.firstPartAttributedString)
        self.attributedString.append(self.lastWordAttributedString)
        
        return event
    }
}
