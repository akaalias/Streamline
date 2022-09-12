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
    
    init() {
        allCharacters = []
        scene = ParticleScene()
        scene.scaleMode = .resizeFill
        scene.backgroundColor = .clear
    }
}
