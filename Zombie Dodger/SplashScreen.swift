import SpriteKit

class SplashScreen: SKScene {

    var highScoreLable: SKLabelNode?
    
    override func didMove(to view: SKView) {
        // Dosent need variable name but initialises user defults
        let _ = UserDefaults.standard
        // Adds the highscore to a variable
        
        let highScoreGlobal = UserDefaults().integer(forKey: "highScore")
        
        // Updates node value
        highScoreLable = childNode(withName: "highScoreNode") as? SKLabelNode
        highScoreLable!.text = ("Highscore: \(highScoreGlobal)")
        

        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Transitions to other scene
        let crossFade = SKTransition.crossFade(withDuration: 1.0)
        let gameScene = SKScene(fileNamed: "GameScene")
        gameScene!.scaleMode = .aspectFill
        scene!.view!.presentScene(gameScene!, transition: crossFade)
        
    }
    
    
    
    
}
