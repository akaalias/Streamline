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
    @Published var autocompleteOptions: [String] = ["Music", "Ideas", "News"]
    @Published var selectedAutocompleteOption: String = ""
    @Published var selectIndex = -1

    var timer: Timer?
    
    init() {
        allCharacters = []
        scene = ParticleScene()
        scene.scaleMode = .resizeFill
        scene.backgroundColor = .clear
    }
    
    func autocompleteSearchMatches() -> [String] {
        return autocompleteOptions.filter { $0.contains(searchString.joined()) }
    }
    
    func selectNextAutocompleteOptionsDown() {
        selectIndex += 1
        selectOption()
    }

    func selectNextAutocompleteOptionsUp() {
        selectIndex -= 1
        selectOption()
    }
    
    func selectOption() {
        selectedAutocompleteOption = searchString.joined()

        if(selectIndex >= 0 && selectIndex < autocompleteSearchMatches().count) {
            selectedAutocompleteOption = autocompleteSearchMatches()[selectIndex]
        }
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
