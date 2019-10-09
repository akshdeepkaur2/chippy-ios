//
//  EnemyShot.swift
//  Chippy Game
//
//  Created by Lars Bergqvist on 2015-09-14.
//  
//

import Foundation
import SpriteKit

class EnemyShot {

    class func SpriteName() -> String {
        return "enemyshot"
    }

    var laserSprite = SKSpriteNode(imageNamed: "laserRed13")
    var parent:SKNode?
    var position:CGPoint = CGPoint(x: 0, y: 0)
    
    init(parentNode:SKNode, pos:CGPoint) {
        parent = parentNode
        position = pos
        
        let spTexture = SKTexture(imageNamed: "laserRed13")
        laserSprite = SKSpriteNode(texture: spTexture)
        
        laserSprite.physicsBody = SKPhysicsBody(texture: spTexture, size: laserSprite.size)
        laserSprite.physicsBody?.isDynamic = true
        laserSprite.physicsBody?.allowsRotation = false
        laserSprite.name = EnemyShot.SpriteName()
        
        laserSprite.physicsBody?.categoryBitMask = enemyShotBitMask
        laserSprite.physicsBody?.collisionBitMask = playerBitMask
        laserSprite.physicsBody?.contactTestBitMask = playerBitMask
    }
    
    func Shoot(_ finalPos:CGPoint, ifTopFire: Bool = false, distanceFromFinalPos: CGFloat = 0.0) -> Void {
        
        laserSprite.position = self.position
        
        parent?.addChild(laserSprite)

        guard let finalPos1 = laserSprite.parent?.frame.height else { return }
        
        let moveAction = ifTopFire ? SKAction.moveBy(x: distanceFromFinalPos, y: finalPos1 + 200.0, duration: 0.5) : SKAction.move(to: finalPos, duration: 0.5)
        
        //let moveAction = SKAction.move(to: finalPos, duration: 0.5)

        let arc = atan2(finalPos.x - position.x, position.y - finalPos.y)
        if !ifTopFire {
            laserSprite.zRotation = arc
        }


        moveAction.timingMode = SKActionTimingMode.easeInEaseOut

        laserSprite.run(moveAction)
    }
    
}
