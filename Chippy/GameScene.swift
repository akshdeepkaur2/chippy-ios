//
//  GameScene.swift
//  Chippy Game
//
//  Created by Rohit Kumar
//  
//

import SpriteKit
import CoreMotion
import AudioToolbox

typealias EnemyHitHandler = ( (SKNode,SKNode) -> Void)
typealias PlayerHitHandler = ((SKNode,SKNode,CGPoint) -> Void)

let laserShotBitMask:UInt32 = 0x01
let enemyBitMask:UInt32 = 0x02
let playerBitMask:UInt32 = 0x04
let enemyShotBitMask:UInt32 = 0x08

class GameScene: SKScene {
    
    let spaceShip:SpaceShip = SpaceShip(initialYPos: 100.0)
    let motionManager: CMMotionManager = CMMotionManager()
    var enemySpawner:EnemySpawner?
    var collisionDetector : CollisionDetector?
    var bgHeight:CGFloat = 0.0
    let bgMusic = BackGroundMusic()
    var bgGfx:BackgroundGfx?
    let explosionPlayer = ExplosionPlayer()
    
    var timer: Timer?
    var isFirstTime = true

    override func didMove(to view: SKView) {
        if isFirstTime {
            isFirstTime = false
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateScoreLabel), userInfo: nil, repeats: true)
        }
        bgGfx = BackgroundGfx(parent:self)
        bgGfx?.setupBackgroup()

        self.anchorPoint = CGPoint(x: 0, y: 0)
        
        setupPhysicsWorld()
        
        setupScorebar()
        
        spaceShip.addShipToParent(self,pos: CGPoint( x: self.frame.midX, y: spaceShip.initialYPos))
        
        enemySpawner = EnemySpawner(parent: self)
        
        updateScoreLabel()
        
        updateEnergyMeter()
        
        bgMusic.playSound()

        motionManager.startAccelerometerUpdates()
    }
    struct Weapon {
        var position:CGPoint
    }
    
    func rotate(vector:CGVector, angle:CGFloat) -> CGVector {
        let rotatedX = vector.dx * cos(angle) - vector.dy * sin(angle)
        let rotatedY = vector.dx * sin(angle) + vector.dy * cos(angle)
        return CGVector(dx: rotatedX, dy: rotatedY)
    }
    
    func shoot(weapon:Weapon, from node:SKNode) {
        // Convert the position from the character's coordinate system to scene coodinates
        let converted = node.convert(weapon.position, to: self)
        
        // Determine the direction of the bullet based on the character's rotation
//        let vector = rotate(CGVector(dx: 0.25, dy: 0), angle:node.zRotation + rotationOffset)
//
        let vector = rotate(vector: CGVector(dx: 0.25, dy: 0), angle:node.zRotation + 0)
        
        
        // Create a bullet with a physics body
        let bullet = SKSpriteNode(color: SKColor.blue, size: CGSize(width: 4,height: 4))
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: 2)
        bullet.physicsBody?.affectedByGravity = false
        bullet.position = CGPoint(x: converted.x, y: converted.y)
        addChild(bullet)
        bullet.physicsBody?.applyImpulse(vector)
    }
    let sprite = SKSpriteNode(imageNamed:"enemyRed1")
    let dualGuns = [Weapon(position: CGPoint(x: -15, y: 15)), Weapon(position: CGPoint(x: 15, y: 15))]
    let singleGun = [Weapon(position: CGPoint(x: 0, y: 15))]
    let numGuns = 2
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        if let _ = touches.first {
            let action = SKAction.rotate(byAngle: CGFloat(M_PI_4/2), duration: 1)
            sprite.run(action) {
                [weak self] in
                if let scene = self {
                    switch (scene.numGuns) {
                    case 1:
                        for weapon in scene.singleGun {
                            scene.shoot(weapon: weapon, from: scene.sprite)
                        }
                    case 2:
                        for weapon in scene.dualGuns {
                            scene.shoot(weapon: weapon, from: scene.sprite)
                        }
                    default:
                        break
                    }
                }
            }
        }
        spaceShip.firePressed = true
    }
    
    var waitCounter = 0
    var isNewEnemy = false
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
        processUserMotionForUpdate(currentTime)
        spaceShip.updateActions()
        
        if !isNewEnemy {
            spawnNewEnemy(pos: 0)
            spawnNewEnemy(pos: 1)
            spawnNewEnemy(pos: 2)
            spawnNewEnemy(pos: 3)
            spawnNewEnemy(pos: 4)
            spawnNewEnemy(pos: 5)
            spawnNewEnemy(pos: 6)
            spawnNewEnemy(pos: 7)
            spawnNewEnemy(pos: 8)
            spawnNewEnemy(pos: 9)
            spawnNewEnemy(pos: 10)
            spawnNewEnemy(pos: 11)
            spawnNewEnemy(pos: 12)
            spawnNewEnemy(pos: 13)
            spawnNewEnemy(pos: 14)
            spawnNewEnemy(pos: 15)
            spawnNewEnemy(pos: 16)
            spawnNewEnemy(pos: 17)
            spawnNewEnemy(pos: 18)
            spawnNewEnemy(pos: 19)
            spawnNewEnemy(pos: 20)
            spawnNewEnemy(pos: 21)
            spawnNewEnemy(pos: 22)
            spawnNewEnemy(pos: 23)
            spawnNewEnemy(pos: 24)
            spawnNewEnemy(pos: 25)
            spawnNewEnemy(pos: 26)
            //spawnNewEnemy(pos: 27)
            isNewEnemy = true
        }

//        spawnNewEnemy()
//        if (waitCounter > 100)
//        {
//            enemySpawner?.removeEnemiesOutsideScreen()
//            waitCounter = 0
//        }
//        waitCounter += 1
        bgGfx?.scrollBackground()
    }

    func setupPhysicsWorld()
    {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.name = "edge"
        collisionDetector = CollisionDetector(g:enemyHit, e:playerHit)
        self.physicsWorld.contactDelegate = collisionDetector
    }
    
    let explosion = ExplosionAtlas()
    
    func enemyHit(_ enemyNode:SKNode,laserNode:SKNode) {
        laserNode.removeFromParent()
        enemyNode.physicsBody?.isDynamic = false
        enemyNode.physicsBody?.categoryBitMask = 0
        print("hit-->>\(enemyNode.name)")
        score += 1
        updateScoreLabel()
        let enemyName = enemyNode.name
        enemyNode.name = ""
        
        explosionPlayer.playSound()
        let timerPerFrame = enemyName == "mainEnemy" ? 0.05 : 0.05
        
        let expl = SKAction.animate(with: explosion.expl_01_(), timePerFrame: timerPerFrame)
        let enemySprite = enemyNode as! SKSpriteNode
        enemySprite.run(expl, completion: { () -> Void in
            enemyNode.removeFromParent()
            if enemyName == "mainEnemy" {
                self.enemySpawner?.removeEnemiesOutsideScreen()
                self.endGame(isEnemyWon: false)
                return
            }
        })
    }
    
    let hitAtlas = HitAtlas()
    
    func playerHit(_ player:SKNode,hitObject:SKNode,contactPoint:CGPoint) {
        hitObject.name = ""
        energy -= 1
        updateEnergyMeter()
        hitObject.removeFromParent()
        
        // Vibrate device
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        // Animate a hit on the player ship
        let pointInSprite = player.convert(contactPoint, from: self)
        let hit = SKSpriteNode(texture: hitAtlas.laserBlue08())
        hit.position = pointInSprite
        hit.zPosition = 10
        player.addChild(hit)
        let expl = SKAction.animate(with: hitAtlas.laserBlue(), timePerFrame: 0.05)
        hit.run(expl, completion: { () -> Void in
            hit.removeFromParent()
        })
        
        if (energy < 1) {
            endGame(isEnemyWon: true)
        }
    }
    
    func endGame(isEnemyWon: Bool = false) {
        if timer != nil {
            timer?.invalidate()
            timer = nil
            isFirstTime = true
        }
        let transition = SKTransition.reveal(with: SKTransitionDirection.down, duration: 3.0)
        let scene = GameOverScene(size: self.scene!.size)
        scene.wonOrLoseText = isEnemyWon ? "You Lost the Game " : "Congrats! You won the game"
        scene.score = score
        scene.scaleMode = SKSceneScaleMode.aspectFit
        scene.backgroundColor = UIColor.black
        
        self.scene?.view?.presentScene(scene, transition: transition)
        bgMusic.StopSound()
    }
    
    var timeBetweenSpawns = 200
    var count = 0
    
    func spawnNewEnemy(pos: Int = 0) {
        enemySpawner?.spawnNewEnemy(spaceShip.GetCurrentPosition(), pos: pos)
    }
    
    func processUserMotionForUpdate(_ currentTime: CFTimeInterval) {
        if let data = motionManager.accelerometerData {
            
            if (data.acceleration.x > 0.2) {
                spaceShip.horizontalAction = .moveRight
                spaceShip.horizontalSpeed = fabs(data.acceleration.x)
                
            }
            else if (data.acceleration.x < -0.2) {
                spaceShip.horizontalAction = .moveLeft
                spaceShip.horizontalSpeed = fabs(data.acceleration.x)
                
            }
            else {
                spaceShip.horizontalAction = .none
                spaceShip.horizontalSpeed = 0.0
            }
            
            if (data.acceleration.y > 0.2) {
                spaceShip.verticalAction = .moveUp
                spaceShip.verticalSpeed = fabs(data.acceleration.y)
                
            }
            else if (data.acceleration.y < -0.2) {
                spaceShip.verticalAction = .moveDown
                spaceShip.verticalSpeed = fabs(data.acceleration.y)
                
            }
            else {
                spaceShip.verticalAction = .none
                spaceShip.verticalSpeed = 0.0
            }

        }
    }
    
    var score = 0
    let scoreLabel = SKLabelNode(fontNamed:"HelveticaNeue")
    
    let playerYPos = 100.0
    
    @objc func updateScoreLabel() {
        score += 1
        scoreLabel.text = "Score: \(score)"
    }
    
    var energy = 5
    let energyLabel = SKLabelNode(fontNamed: "HelveticaNeue")
    let energyMeter = SKLabelNode(fontNamed:"HelveticaNeue")
    
    func updateEnergyMeter() {
        var energyBar = ""
        if (energy > 0)
        {
            for _ in 0...energy-1 {
                energyBar += "❤️"
            }
        }
        energyMeter.text = energyBar
    }

    func setupScorebar()
    {
        scoreLabel.fontSize = 25;
        scoreLabel.position = CGPoint(x: 100,y: 0)
        self.addChild(scoreLabel)
        energyLabel.fontSize = 25;
        energyLabel.position = CGPoint(x: self.frame.width-200,y: 0)
        self.addChild(energyLabel)
        energyMeter.fontSize = 25;
        energyMeter.position = CGPoint(x: self.frame.width-250,y: 0)
        self.addChild(energyMeter)
    }
}
