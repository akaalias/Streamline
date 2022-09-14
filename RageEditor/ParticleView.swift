//
//  ParticleView.swift
//  RageEditor
//
//  Created by Alexis Rondeau on 11.09.22.
//

import SpriteKit

class ParticleScene: SKScene {

    public var snowEmitterNode = SKEmitterNode(fileNamed: "SparkParticle.sks")

    func emitOne() {
        self.start()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
            self.stop()
        })
    }
    
    func start() {
        guard let snowEmitterNode = snowEmitterNode else { return }
        snowEmitterNode.particleBirthRate = 1
    }
    
    func stop() {
        guard let snowEmitterNode = snowEmitterNode else { return }
        snowEmitterNode.particleBirthRate = 0
    }

    override func didMove(to view: SKView) {
        guard let snowEmitterNode = snowEmitterNode else { return }

        snowEmitterNode.particlePosition = CGPoint(x: size.width * 0.62, y: (size.height / 2) - 40)
        snowEmitterNode.particleBirthRate = 0

        addChild(snowEmitterNode)
    }

    override func didChangeSize(_ oldSize: CGSize) {
        guard let snowEmitterNode = snowEmitterNode else { return }

        snowEmitterNode.particlePosition = CGPoint(x: size.width * 0.62, y: (size.height / 2) - 40)
        snowEmitterNode.particleBirthRate = 0
    }
}
