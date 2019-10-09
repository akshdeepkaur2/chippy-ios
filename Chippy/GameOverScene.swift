import Foundation
import SpriteKit

class GameOverScene : SKScene {
    
    let restartLabel = SKLabelNode(fontNamed:"HelveticaNeue")
    let instructionsLabel = SKLabelNode(fontNamed:"HelveticaNeue")
    let instructionsLabel2 = SKLabelNode(fontNamed:"HelveticaNeue")
    
    var score = 0
    var wonOrLoseText = ""
    
    override func didMove(to view: SKView) {
        instructionsLabel.text = wonOrLoseText
        instructionsLabel.fontSize = 40;
        instructionsLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY);
        self.addChild(instructionsLabel)
        
        instructionsLabel2.text = "Your score was: \(score)"
        instructionsLabel2.fontSize = 40;
        instructionsLabel2.position = CGPoint(x:self.frame.midX, y:self.frame.midY-100);
        self.addChild(instructionsLabel2)
        
        restartLabel.text = "Tap to restart"
        restartLabel.fontSize = 45;
        restartLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY-250);
        self.addChild(restartLabel)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        startGame()
    }
    
    func startGame() {
        
        let transition = SKTransition.reveal(with: SKTransitionDirection.down, duration: 1.0)
        
        let scene = GameScene(size: self.scene!.size)
        scene.scaleMode = SKSceneScaleMode.aspectFit
        scene.backgroundColor = UIColor.black
        
        self.scene?.view?.presentScene(scene, transition: transition)
    }
}
