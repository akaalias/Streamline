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
    
    var timer: Timer?
    
    init() {
        allCharacters = []
        scene = ParticleScene()
        scene.scaleMode = .resizeFill
        scene.backgroundColor = .clear
    }
    
    func autocompleteSearchMatches() -> [String] {
        if(searchString.count <= 3) { return [] }
        return markdownFileNames.filter { $0.localizedCaseInsensitiveContains(searchString.joined()) }
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
