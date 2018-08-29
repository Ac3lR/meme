import SpriteKit

class SplashScreen: SKScene {

    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        let crossFade = SKTransition.crossFade(withDuration: 1.0)
        let gameScene = SKScene(fileNamed: "GameScene")
        gameScene!.scaleMode = .aspectFill
        scene!.view!.presentScene(gameScene!, transition: crossFade)
        
    }
    
    
    
    
}
