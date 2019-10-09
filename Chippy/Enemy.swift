//
//  Enemy.swift
//  Chippy Game
//
//  Created by Lars Bergqvist on 2015-09-14.
//  
//

import Foundation
import SpriteKit

class Enemy : NSObject {
   
    var canFireLaser = false
    var enemySprite:SKSpriteNode?
    var timer = Timer()
    var fireTimer = Timer()
    
    var fireTimerLeft = Timer()
    var fireTimerRight = Timer()
    var fireTimerTop = Timer()
    var fireTimerTopLeft = Timer()
    var fireTimerTopRight = Timer()
    var fireTimerBottom = Timer()
    
    
    class func SpriteName() -> String {
        return "enemy"
    }
    
    var finalPos: CGPoint = CGPoint(x: 0, y: 0)
    
    init(imageName:String,canFire:Bool) {
        super.init()
        
        canFireLaser = canFire
        
        let spTexture = SKTexture(imageNamed: imageName)
        enemySprite = SKSpriteNode(texture: spTexture)
        enemySprite?.name = Enemy.SpriteName()
        enemySprite?.position = CGPoint(x: 0, y: 500)

        enemySprite?.physicsBody = SKPhysicsBody(texture: spTexture, size: enemySprite!.size)
        enemySprite?.physicsBody?.isDynamic = false
        enemySprite?.physicsBody?.categoryBitMask = enemyBitMask
        enemySprite?.physicsBody?.collisionBitMask = laserShotBitMask
        enemySprite?.physicsBody?.contactTestBitMask = laserShotBitMask
//        enemySprite?.zRotation = CGFloat(45.degreesToRadians)

     //   enemySprite?.physicsBody?.affectedByGravity = false
        enemySprite?.physicsBody?.allowsRotation = false

        if (canFire) {
            timer = Timer.scheduledTimer(timeInterval: 8, target: self, selector: #selector(Enemy.fireGun), userInfo: nil, repeats: true)
        }
    }
    
    @objc func fireGun() {
        if (enemySprite != nil && enemySprite!.parent != nil) {
            if (enemySprite?.name == "mainEnemy") {
                //shot.Shoot(finalPos)
                //fireTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(Enemy.fireTimerFiring), userInfo: nil, repeats: true)
                
                fireTimerLeft = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(Enemy.fireTimerFiringLeft), userInfo: nil, repeats: true)
                fireTimerRight = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(Enemy.fireTimerFiringRight), userInfo: nil, repeats: true)
                fireTimerTop = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(Enemy.fireTimerFiringTop), userInfo: nil, repeats: true)
                fireTimerTopRight = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(Enemy.fireTimerFiringTopExtremeRight), userInfo: nil, repeats: true)
                fireTimerTopLeft = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(Enemy.fireTimerFiringTopExtremeLeft), userInfo: nil, repeats: true)
                
                
                fireTimerBottom = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(Enemy.fireTimerFiringBottom), userInfo: nil, repeats: true)
            }
        }
    }
    
    var timerCounter = 0.0
    var timerCounterLeft = 0.0
    var timerCounterRight = 0.0
    var timerCounterTop = 0.0
    var timerCounterTopRight = 0.0
    var timerCounterTopLeft = 0.0
    var timerCounterBottom = 0.0
    
    @objc func fireTimerFiring() {
        
        if timerCounter == 5.0{
            fireTimer.invalidate()
            timerCounter = 0.0
            return
            //enemySprite?.removeFromParent()
        }
        
        guard let parent = enemySprite?.parent else {
            fireTimer.invalidate()
            timerCounter = 0.0
            return
        }
        
        var dx = enemySprite!.position.x - (enemySprite?.parent?.position.x)!
        var dy = enemySprite!.position.y - (enemySprite?.parent?.position.y)!
        
        var magnitude = sqrt(dx * dx + dy * dy)
        
        dx /= magnitude
        dy /= magnitude
        
        let vector = CGVector(dx: 16.0 * dx, dy: 16.0 * dy)
        
        //enemySprite?.physicsBody?.applyImpulse(vector)
        
        let shot = EnemyShot(parentNode: enemySprite!.parent!, pos:CGPoint(x: enemySprite!.position.x,y: enemySprite!.position.y - enemySprite!.size.height))
        
        enemySprite?.position = CGPoint(x: enemySprite!.position.x, y: enemySprite!.position.y)
        //enemySprite?.zRotation = CGFloat(45.degreesToRadians)
        //enemySprite?.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        enemySprite?.physicsBody!.affectedByGravity = false
//        enemySprite?.physicsBody!.categoryBitMask = PhysicsCategories.enemy
//        enemySprite?.physicsBody!.collisionBitMask = PhysicsCategories.none
//        enemySprite?.physicsBody!.contactTestBitMask = PhysicsCategories.player
        shot.Shoot(finalPos)
        timerCounter += 0.5
        removeShotsOutsideScreen()
    }
    
    @objc func fireTimerFiringLeft() {
        
        if timerCounterLeft == 5.0{
            fireTimerLeft.invalidate()
            timerCounterLeft = 0.0
            return
        }
        
        guard let parent = enemySprite?.parent else {
            fireTimerLeft.invalidate()
            timerCounterLeft = 0.0
            return
        }
        
        let leftFinalPos = CGPoint(x: 50, y: finalPos.y)
        let shot = EnemyShot(parentNode: enemySprite!.parent!, pos:CGPoint(x: enemySprite!.position.x,y: enemySprite!.position.y - enemySprite!.size.height))
        
        enemySprite?.position = CGPoint(x: enemySprite!.position.x, y: enemySprite!.position.y)
        enemySprite?.physicsBody!.affectedByGravity = false
        shot.Shoot(leftFinalPos)
        timerCounterLeft += 0.5
        removeShotsOutsideScreen()
    }
    
    @objc func fireTimerFiringRight() {
        
        if timerCounterRight == 5.0{
            fireTimerRight.invalidate()
            timerCounterRight = 0.0
            return
        }
        
        guard let parent = enemySprite?.parent else {
            fireTimerRight.invalidate()
            timerCounterRight = 0.0
            return
        }
        
        let rightFinalPos = CGPoint(x: finalPos.x + 200, y: finalPos.y)
        
        let shot = EnemyShot(parentNode: enemySprite!.parent!, pos:CGPoint(x: enemySprite!.position.x,y: enemySprite!.position.y - enemySprite!.size.height))
        
        enemySprite?.position = CGPoint(x: enemySprite!.position.x, y: enemySprite!.position.y)
        enemySprite?.physicsBody!.affectedByGravity = false
        shot.Shoot(rightFinalPos)
        timerCounterRight += 0.5
        removeShotsOutsideScreen()
    }
    
    @objc func fireTimerFiringTop() {
        
        if timerCounterTop == 5.0{
            fireTimerTop.invalidate()
            timerCounterTop = 0.0
            return
        }
        
        guard (enemySprite?.parent) != nil else {
            fireTimerTop.invalidate()
            timerCounterTop = 0.0
            return
        }
        
        let topFinalPos = CGPoint(x: 200, y: finalPos.y)
        
        let shot = EnemyShot(parentNode: enemySprite!.parent!, pos:CGPoint(x: enemySprite!.position.x,y: enemySprite!.position.y - enemySprite!.size.height))
        
        enemySprite?.position = CGPoint(x: enemySprite!.position.x, y: enemySprite!.position.y)
        enemySprite?.physicsBody!.affectedByGravity = false
        shot.Shoot(topFinalPos, ifTopFire: true)
        timerCounterTop += 0.5
        removeShotsOutsideScreen()
    }
    
    @objc func fireTimerFiringTopExtremeRight() {
        
        if timerCounterTopRight == 5.0{
            fireTimerTopRight.invalidate()
            timerCounterTopRight = 0.0
            return
        }
        
        guard (enemySprite?.parent) != nil else {
            fireTimerTopRight.invalidate()
            timerCounterTopRight = 0.0
            return
        }
        
        let topFinalPos = CGPoint(x: 200, y: finalPos.y)
        
        let shot = EnemyShot(parentNode: enemySprite!.parent!, pos:CGPoint(x: enemySprite!.position.x,y: enemySprite!.position.y - enemySprite!.size.height))
        
        enemySprite?.position = CGPoint(x: enemySprite!.position.x, y: enemySprite!.position.y)
        enemySprite?.physicsBody!.affectedByGravity = false
        shot.Shoot(topFinalPos, ifTopFire: true, distanceFromFinalPos: finalPos.x + 200)
        timerCounterTopRight += 0.5
        removeShotsOutsideScreen()
    }
    
    
    @objc func fireTimerFiringTopExtremeLeft() {
        
        if timerCounterTopLeft == 5.0{
            fireTimerTopLeft.invalidate()
            timerCounterTopLeft = 0.0
            return
        }
        
        guard (enemySprite?.parent) != nil else {
            fireTimerTopLeft.invalidate()
            timerCounterTopLeft = 0.0
            return
        }
        
        let topFinalPos = CGPoint(x: 200, y: finalPos.y)
        
        let shot = EnemyShot(parentNode: enemySprite!.parent!, pos:CGPoint(x: enemySprite!.position.x,y: enemySprite!.position.y - enemySprite!.size.height))
        
        enemySprite?.position = CGPoint(x: enemySprite!.position.x, y: enemySprite!.position.y)
        enemySprite?.physicsBody!.affectedByGravity = false
        shot.Shoot(topFinalPos, ifTopFire: true, distanceFromFinalPos: finalPos.x - 200)
        timerCounterTopLeft += 0.5
        removeShotsOutsideScreen()
    }
    
    
    @objc func fireTimerFiringBottom() {
        
        if timerCounterBottom == 5.0{
            fireTimerBottom.invalidate()
            timerCounterBottom = 0.0
            return
        }
        
        guard let parent = enemySprite?.parent else {
            fireTimerBottom.invalidate()
            timerCounterBottom = 0.0
            return
        }
        
        let bottomFinalPos = CGPoint(x: finalPos.x , y: finalPos.y)
        
        let shot = EnemyShot(parentNode: enemySprite!.parent!, pos:CGPoint(x: enemySprite!.position.x,y: enemySprite!.position.y - enemySprite!.size.height))
        
        enemySprite?.position = CGPoint(x: enemySprite!.position.x, y: enemySprite!.position.y)
        enemySprite?.physicsBody!.affectedByGravity = false
        shot.Shoot(bottomFinalPos)
        timerCounterBottom += 0.5
        removeShotsOutsideScreen()
    }
    
    func removeShotsOutsideScreen() {
        enemySprite?.parent?.enumerateChildNodes(withName: "*") {
            node,stop in
            if let name = node.name {
                if (name == EnemyShot.SpriteName()) {
                    let finalPos = node.parent?.frame.height
                    
                    if (node.position.y >= finalPos! - 300) {
                        node.removeFromParent()
                    }
                }
            }
        }
        
    }
}
