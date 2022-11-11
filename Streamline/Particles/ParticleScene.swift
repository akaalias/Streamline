//
//  ParticleScene.swift
//  Streamline
//
//  Created by Alexis Rondeau on 11.11.22.
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
        if(children.count <= 0) {
            guard let snowEmitterNode = snowEmitterNode else { return }

            snowEmitterNode.particlePosition = CGPoint(x: size.width * 0.6, y: (size.height))
            snowEmitterNode.particleBirthRate = 0

            addChild(snowEmitterNode)
        }
    }

    override func didChangeSize(_ oldSize: CGSize) {
        if(children.count <= 0) {
            guard let snowEmitterNode = snowEmitterNode else { return }
            
            snowEmitterNode.particlePosition = CGPoint(x: size.width * 0.6, y: (size.height))
            snowEmitterNode.particleBirthRate = 0
        }
    }
}
