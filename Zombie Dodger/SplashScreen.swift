import SpriteKit

class SplashScreen: SKScene {

    var highScoreLable: SKLabelNode?
    
    override func didMove(to view: SKView) {
        
        let _ = UserDefaults.standard

        let highScoreGlobal = UserDefaults().integer(forKey: "highScore")
        highScoreLable = childNode(withName: "highScoreNode") as? SKLabelNode
        highScoreLable!.text = ("Highscore: \(highScoreGlobal)")
        

        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        let crossFade = SKTransition.crossFade(withDuration: 1.0)
        let gameScene = SKScene(fileNamed: "GameScene")
        gameScene!.scaleMode = .aspectFill
        scene!.view!.presentScene(gameScene!, transition: crossFade)
        
    }
    
    
    
    
}
