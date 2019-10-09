//
//  EnemySpawner.swift
//  Chippy Game
//
//  Created by Lars Bergqvist on 2015-09-14.
//
//

import Foundation
import SpriteKit

class EnemySpawner: NSObject {
    var parentNode:SKNode?
    
    var numAngles: Double = 15
    let magnitude = 1;
    var angleIncr :Double = 0//fmod(angle1 + angleIncr, 2*M_PI);
    
    var angle1: Double = 0
    
    init(parent:SKNode) {
        parentNode = parent
    }
    
    func spawnNewEnemy(_ targetPoint:CGPoint, pos: Int = 0) {
        
        //let imgIdx = Int(arc4random_uniform(UInt32(images.count)))
        let imageName = pos == 13 ? "powerupRed_shield" : "powerupGreen"
        
        let canFire = pos == 13 ? true : false
//        var canFire = false
//        if (imageName.contains("Red")) {
//            canFire=true
//        }
        let enemy = Enemy(imageName: imageName, canFire: canFire)
        
        let sp = enemy.enemySprite!

        if pos == 13 {
            sp.name = "mainEnemy"
        }
        
        parentNode?.addChild(sp)
        
        //previous
//        let dice1 = arc4random_uniform(UInt32(sp.parent!.frame.size.width-sp.size.width))
        
        //let startPos = CGPoint(x: CGFloat(dice1)+sp.size.width/2,y: sp.parent!.frame.height+sp.size.height)
        var xPos: CGFloat = 0
        var yPos: CGFloat = 0
        
        switch pos {
        case 0:
            xPos = sp.parent!.frame.width/2 + 18
            yPos = sp.parent!.frame.height+sp.size.height + 200//85
        case 1:
            xPos = sp.parent!.frame.width/2 - 18
            yPos = sp.parent!.frame.height+sp.size.height + 200


        case 2:
            xPos = sp.parent!.frame.width/2 + 35
            yPos = sp.parent!.frame.height+sp.size.height + 170
        case 3:
            xPos = sp.parent!.frame.width/2 + 0
            yPos = sp.parent!.frame.height+sp.size.height + 170
        case 4:
            xPos = sp.parent!.frame.width/2 - 35
            yPos = sp.parent!.frame.height+sp.size.height + 170

        case 5:
            xPos = sp.parent!.frame.width/2 + 70
            yPos = sp.parent!.frame.height+sp.size.height + 140
        case 6:
            xPos = sp.parent!.frame.width/2 + 35
            yPos = sp.parent!.frame.height+sp.size.height + 140
        case 7:
            xPos = sp.parent!.frame.width/2 + 0
            yPos = sp.parent!.frame.height+sp.size.height + 140
        case 8:
            xPos = sp.parent!.frame.width/2 - 35
            yPos = sp.parent!.frame.height+sp.size.height + 140
        case 9:
            xPos = sp.parent!.frame.width/2 - 70
            yPos = sp.parent!.frame.height+sp.size.height + 140

            
        case 10:
            xPos = sp.parent!.frame.width/2 + 105
            yPos = sp.parent!.frame.height+sp.size.height + 110
        case 11:
            xPos = sp.parent!.frame.width/2 + 70
            yPos = sp.parent!.frame.height+sp.size.height + 110
        case 12:
            xPos = sp.parent!.frame.width/2 + 35
            yPos = sp.parent!.frame.height+sp.size.height + 110
        case 13:
            xPos = sp.parent!.frame.width/2 + 0
            yPos = sp.parent!.frame.height+sp.size.height + 110
        case 14:
            xPos = sp.parent!.frame.width/2 - 35
            yPos = sp.parent!.frame.height+sp.size.height + 110
        case 15:
            xPos = sp.parent!.frame.width/2 - 70
            yPos = sp.parent!.frame.height+sp.size.height + 110
        case 16:
            xPos = sp.parent!.frame.width/2 - 105
            yPos = sp.parent!.frame.height+sp.size.height + 110
            
            
        case 17:
            xPos = sp.parent!.frame.width/2 + 70
            yPos = sp.parent!.frame.height+sp.size.height + 80
        case 18:
            xPos = sp.parent!.frame.width/2 + 35
            yPos = sp.parent!.frame.height+sp.size.height + 80
        case 19:
            xPos = sp.parent!.frame.width/2 + 0
            yPos = sp.parent!.frame.height+sp.size.height + 80
        case 20:
            xPos = sp.parent!.frame.width/2 - 35
            yPos = sp.parent!.frame.height+sp.size.height + 80
        case 21:
            xPos = sp.parent!.frame.width/2 - 70
            yPos = sp.parent!.frame.height+sp.size.height + 80

        
        case 22:
            xPos = sp.parent!.frame.width/2 + 35
            yPos = sp.parent!.frame.height+sp.size.height + 50
        case 23:
            xPos = sp.parent!.frame.width/2 + 0
            yPos = sp.parent!.frame.height+sp.size.height + 50
        case 24:
            xPos = sp.parent!.frame.width/2 - 35
            yPos = sp.parent!.frame.height+sp.size.height + 50
            

        case 25:
            xPos = sp.parent!.frame.width/2 - 18
            yPos = sp.parent!.frame.height+sp.size.height + 20
        case 26:
            xPos = sp.parent!.frame.width/2 + 18
            yPos = sp.parent!.frame.height+sp.size.height + 20

        default:
            xPos = sp.parent!.frame.width/2 - 35
            yPos = sp.parent!.frame.height+sp.size.height + 20
        }

        let startPos = CGPoint(x: xPos, y: yPos)
        sp.position = startPos
        
        //Previous
//                let startPos = CGPoint(x: CGFloat(dice1)+sp.size.width/2,y: sp.parent!.frame.height+sp.size.height)
//        sp.position = startPos
        //        let speed = Int(arc4random_uniform(3))+3
        
        let speed = 20
        angleIncr = 2 * Double.pi / numAngles
        
        let res = GetFinalPosAndAngle(startPos,targetPoint: targetPoint, pos: pos)
        
        angle1 = fmod(angle1 + angleIncr, 2 * Double.pi)
        
        let planeRes = GetFinalPosAndAngleForPlane(startPos,targetPoint: targetPoint, pos: pos)
        //sp.zRotation = planeRes.arc
        
        let moveAction = SKAction.move(to: planeRes.finalPos, duration: TimeInterval(speed))
        enemy.finalPos = res.finalPos
        
        sp.run(moveAction)
        
        sp.zRotation = res.arc
    }
    
    func GetFinalPosAndAngle(_ startPos:CGPoint,targetPoint:CGPoint, pos: Int = 0) -> (finalPos:CGPoint,arc:CGFloat)
    {
        let dx = targetPoint.x-startPos.x
        let dy = startPos.y-targetPoint.y
        let ratio = (dx)/(dy)
        let x = startPos.x + ratio*(startPos.y)
        
        var angle = atan2(dx,dy)
        
        switch pos {
        case 0:
            angle = angle - 80
        case 1:
            angle = angle - 60
        case 2:
            angle = angle - 40
        case 3:
            angle = angle - 20
        case 4:
            angle = angle + 0
            
        case 5:
            angle = angle + 20
        case 6:
            angle = angle + 40
        case 7:
            angle = angle + 60
        case 8:
            angle = angle + 80
        default:
            angle = angle + 100
        }
        var angleNew = CGFloat(angle)//atan2(dx,dy)
        angleNew = angleNew - 0.5
        print("angle own \(angleNew)")
        
        return (CGPoint(x: x, y: -100), CGFloat(0))
    }
    
    func GetFinalPosAndAngleForPlane(_ startPos:CGPoint,targetPoint:CGPoint, pos: Int = 0) -> (finalPos:CGPoint,arc:CGFloat)
    {
        let dx = targetPoint.x-startPos.x
        let dy = startPos.y-targetPoint.y
        let ratio = (dx)/(dy)
        let x = startPos.x + ratio*(startPos.y)
        let angle = atan2(dx,dy)
        
        
        var valueToReduce: CGFloat = 700
        
        switch pos {
        case 0,1:
            valueToReduce = valueToReduce - 20
        case 2,3,4:
            valueToReduce = valueToReduce - 50
        case 5,6,7,8,9:
            valueToReduce = valueToReduce - 80
        case 10,11,12,13,14,15,16:
            valueToReduce = valueToReduce - 110
        case 17,18,19,20,21:
            valueToReduce = valueToReduce - 140
        case 22,23,24:
            valueToReduce = valueToReduce - 170
        case 25,26:
            valueToReduce = valueToReduce - 200
        default:
            print("none")
        }
        
        return (CGPoint(x: startPos.x, y: valueToReduce), 0)
    }
    
    let images = ["powerupGreen","powerupGreen","powerupGreen","powerupGreen","powerupGreen","powerupRed_shield","powerupGreen","powerupGreen","powerupGreen","powerupGreen","powerupGreen","powerupGreen","powerupGreen"]
    let images2 = ["enemyRed1"]
    
    let explosion = ExplosionAtlas()
    
    func removeEnemiesOutsideScreen() {
        parentNode?.enumerateChildNodes(withName: "*") {
            node,stop in
            if let name = node.name {
//                if (name == Enemy.SpriteName() || name == EnemyShot.SpriteName()) {
//                    let finalPos = 180.0
                
                    //if (node.position.y <= CGFloat(finalPos)) {
                        node.removeFromParent()
                    //}
                //}
                
                let expl = SKAction.animate(with: self.explosion.expl_01_(), timePerFrame: 0.5)
                let enemySprite = node as! SKSpriteNode
                enemySprite.run(expl, completion: { () -> Void in
                    node.removeFromParent()
                })
                
            }
        }
    }

}
