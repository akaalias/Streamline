//
//  ParticleView.swift
//  RageEditor
//
//  Created by Alexis Rondeau on 11.09.22.
//

import SpriteKit

class ParticleScene: SKScene {

    public var snowEmitterNode = SKEmitterNode(fileNamed: "SnowParticles.sks")
        
    func update(particleCount: Int) {
        guard let snowEmitterNode = snowEmitterNode else { return }

        snowEmitterNode.numParticlesToEmit = particleCount
    }

    func start() {
        guard let snowEmitterNode = snowEmitterNode else { return }

        snowEmitterNode.particleBirthRate = 1
    }
    
    override func didMove(to view: SKView) {
        guard let snowEmitterNode = snowEmitterNode else { return }

        snowEmitterNode.particlePosition = CGPoint(x: size.width * 0.6, y: size.height / 2)
        snowEmitterNode.particleBirthRate = 0
        addChild(snowEmitterNode)
    }

    override func didChangeSize(_ oldSize: CGSize) {
        guard let snowEmitterNode = snowEmitterNode else { return }

        snowEmitterNode.particlePosition = CGPoint(x: size.width * 0.6, y: size.height / 2)
        snowEmitterNode.particleBirthRate = 0
    }
}
