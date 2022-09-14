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
    
    var timer: Timer?
    
    init() {
        allCharacters = []
        scene = ParticleScene()
        scene.scaleMode = .resizeFill
        scene.backgroundColor = .clear
    }
    
    func updateTypingSpeed() {
        secondsElapsed += 1
        if(allCharacters.count > 0) {
            self.typingSpeed = Float(allCharacters.count) / Float(secondsElapsed)
        }
        self.scene.snowEmitterNode?.particleSpeed = CGFloat(-self.typingSpeed)
        self.scene.snowEmitterNode?.xAcceleration = CGFloat(-self.typingSpeed)
    }
    
    @objc func fireTimer() {
        updateTypingSpeed()
    }

    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(fireTimer),
                                     userInfo: [ "foo" : "bar" ],
                                     repeats: true)
    }
}
