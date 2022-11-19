//
//  ParticleScene.swift
//  Streamline
//
//  Created by Alexis Rondeau on 11.11.22.
//

import SpriteKit
import Swift
import SwiftUI

class ParticleScene: SKScene {

    public var snowEmitterNode = SKEmitterNode(fileNamed: "Smoke.sks")

    func emitOne() {
        self.start()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50), execute: {
            self.stop()
        })
    }
    
    func start() {
        guard let snowEmitterNode = snowEmitterNode else { return }
        
        let colors = [NSColor(Color("FireflyColorOne")), NSColor(Color("FireflyColorTwo")), NSColor(Color("FireflyColorThree")), NSColor(Color("FireflyColorFour"))]
        snowEmitterNode.particleColorSequence = nil
        snowEmitterNode.particleColor = colors.randomElement()!
        
        snowEmitterNode.particleBirthRate = 1
    }
    
    func stop() {
        guard let snowEmitterNode = snowEmitterNode else { return }
        
        snowEmitterNode.particleBirthRate = 0
    }

    override func didMove(to view: SKView) {
        if(children.count <= 0) {
            guard let snowEmitterNode = snowEmitterNode else { return }

            snowEmitterNode.particlePosition = CGPoint(x: size.width - 40, y: (size.height) + 80)
            snowEmitterNode.particleBirthRate = 0

            addChild(snowEmitterNode)
        }
    }

    override func didChangeSize(_ oldSize: CGSize) {
        if(children.count <= 0) {
            guard let snowEmitterNode = snowEmitterNode else { return }
            

            snowEmitterNode.particleColor = NSColor.red
            snowEmitterNode.particlePosition = CGPoint(x: size.width - 40, y: (size.height) + 80)
            snowEmitterNode.particleBirthRate = 0
        }
    }
}
