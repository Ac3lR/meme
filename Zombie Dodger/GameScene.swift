// I am committed to being a person of integrity.
// This project is submitted as part of the assessment for Year 10 IST.
// This is all my own work. I have referenced any work used from other
// sources and have not plagiarised the work of others.
// (signed) Axel Raut


//Extention Activities
// 1. Made The game nicer to look at, more pleasing
// 2. Added a level function that increasingly makes the game harder
// 3. Added High Score Functionality with NSUserDefults so even if you restart the app it saves

// By the way sir, you said not to deduct marks for the lagging after lvl 4 because it was hard to solve. ;)
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Declaring Global Variables
    
    //Declaring Categories
    var NinjaCategory: UInt32 = 0x1 << 0
    var ZombieCategory: UInt32 = 0x1 << 1
    var BottomCategory: UInt32 = 0x1 << 2
    
    var ninjaNode: SKSpriteNode?
    
    var lvlNode: SKLabelNode?
    
    var timerNode: SKLabelNode?
    
    var ninjaCreated = false
    
    var fingerOnNinja: Bool = false
    
    var totalTime: Int = 0
    
    var gameTimer: Timer?
    
    var zombieTimer: Timer?
    
    var zombieSpawnTime: Int = 0
    
    var zombieSpawnInterval: Float = 1.0
    
    var gravity: Int = -2
    
    var lvl: Int = 1
    
    var zombieSpawnRate: Int = 1
    
    var firstNinjaCollision: Bool = false
    
    
    override func didMove(to view: SKView) {
                // Spawn Zombies function
                spawnZombies()
        
        
                // Generates Ninja in middle of screen
                let ninjaTexture = SKTexture(imageNamed: "ninja")
                
                ninjaNode = SKSpriteNode(texture: ninjaTexture, size: CGSize(width: ninjaTexture.size().width/3, height: ninjaTexture.size().height/3))
                ninjaNode?.position = CGPoint(x: 0, y: 0)
                ninjaNode?.physicsBody = SKPhysicsBody(texture: ninjaTexture, size: CGSize(width: ninjaTexture.size().width/3, height: ninjaTexture.size().height/3))
                ninjaNode!.physicsBody!.isDynamic = false
                ninjaNode?.name = "ninjaNode"
                ninjaNode?.physicsBody!.categoryBitMask = NinjaCategory
                ninjaNode!.physicsBody!.contactTestBitMask = ZombieCategory
        
                addChild(ninjaNode!)
        
        
                // Creates points for bottom Node
                let bottomLeftPoint = CGPoint(x: -(size.width / 2), y: -950)
                let bottomRightPoint = CGPoint(x: size.width / 2, y: -950)
        
                // Adds Bottom node
                let bottomNode = SKNode()
                bottomNode.physicsBody = SKPhysicsBody(edgeFrom: bottomLeftPoint, to: bottomRightPoint)
                bottomNode.physicsBody!.categoryBitMask = BottomCategory
                addChild(bottomNode)
        
        
                // Creates Score or Timer Node
                timerNode = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
                timerNode!.text = "Score: 1"
                timerNode!.fontSize = 50
                timerNode!.fontColor = SKColor.white
                timerNode!.position = CGPoint(x: -260, y: 600)
                
                addChild(timerNode!)
        
        
                //Creates Lvl Counter or Lvl Node
                lvlNode = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
                lvlNode!.text = "Level 1"
                lvlNode!.fontSize = 50
                lvlNode!.color = UIColor.white
                lvlNode!.position = CGPoint(x: -270, y: 520)
        
                addChild(lvlNode!)
        
                // For Collision detection
                physicsWorld.contactDelegate = self

                //For Gravity
                physicsWorld.gravity = CGVector(dx: 0, dy: gravity)
        
                // Timer for score and also controls zombieSpawnTimer, Adds lvls
                gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (theTimer) in
                    self.totalTime += 1
                    self.timerNode!.text = "Score: \(self.totalTime)"
                    
                    if self.totalTime % 20 == 0 && self.lvl < 5 {
                        
                        self.lvl += 1
                        
                        self.lvlNode!.text = "Level \(self.lvl)"
                        
                    }
                    
                })
        
                // Runs Zombie spawn Function
                zombieTimerFunc()
        
        
    
        

    }
    
  
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Sees where first touch is
        
        let touch = touches.first!
        let touchLocation = touch.location(in: self)
        let touchedNode = atPoint(touchLocation)
        
        
        
            
            
            
        
       // Checks if the touch is on the ninja
        if touchedNode.name == "ninjaNode" {
            fingerOnNinja = true

        }
        
        
        
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        
        //Moves ninja if finger is on ninja
        let touch = touches.first!
        let touchLocation = touch.location(in: self)
        
        if fingerOnNinja == true {
            
        ninjaNode!.position = touchLocation
            
        }
        
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // When finher is off ninja it stops flag
        if fingerOnNinja == true {
            fingerOnNinja = false
        }
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
    
        // We dont use this...... never...
        
    }

    
    func spawnZombies() {
       
        // Spawns zombies in random x position and randomises texture
        var zombieSpawnX = 0
        let randomZombie = Int(arc4random_uniform(4)) + 1
    
        
        let zombieTexture = SKTexture(imageNamed: "zombie\(randomZombie)")
        let zombieNode = SKSpriteNode(texture: zombieTexture, size: CGSize(width: zombieTexture.size().width/3, height: zombieTexture.size().height/3))
        zombieNode.physicsBody = SKPhysicsBody(texture: zombieTexture, size: CGSize(width: zombieTexture.size().width/3, height: zombieTexture.size().height/3))
        zombieNode.physicsBody!.categoryBitMask = ZombieCategory
        zombieNode.physicsBody!.contactTestBitMask = BottomCategory
        zombieNode.physicsBody!.allowsRotation = false
        
        zombieSpawnX = Int(arc4random_uniform(750)) - 375
        zombieNode.position = CGPoint(x: zombieSpawnX, y: 850)
        addChild(zombieNode)
        
        
        
    }

    func resetGame() {
        
        // Changes back to SpashScreen
        let crossFade = SKTransition.crossFade(withDuration: 1.0)
        let gameScene = SKScene(fileNamed: "SplashScreen")
        gameScene!.scaleMode = .aspectFill
        scene!.view!.presentScene(gameScene!, transition: crossFade)
        
        
    }
    
    
    func zombieTimerFunc() {
        
        //Spawns Zombies and implements lvl system
        
        zombieTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(zombieSpawnInterval), repeats: true, block: { (theTimer) in
            
            self.zombieSpawnTime += 1
            print(self.zombieSpawnInterval)
            print(self.zombieSpawnTime)
            
            if self.totalTime % 19 == 0 && self.lvl < 5 {
                
                self.zombieSpawnInterval = (self.zombieSpawnInterval / 1.7)
                self.gravity = (self.gravity * 2)
                print(self.gravity)
                
                
            }
            
            if self.zombieSpawnTime % 3 == 0 {
                
                self.spawnZombies()
                
            }
            
            if self.totalTime % 20 == 0 && self.lvl < 5 {
                
                self.zombieTimer!.invalidate()
                
                self.zombieTimerFunc()
                

                
            }
            
            
        })
        
        
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
       
        //Checks for contact with zombie and bottom node
        if (contact.bodyA.categoryBitMask == BottomCategory) {

          // Removes zombie
            contact.bodyB.node!.removeFromParent()

        }
        // Same, Checks
        if (contact.bodyB.categoryBitMask == BottomCategory) {
            
            // Removes
            contact.bodyA.node!.removeFromParent()
            
        }
        
        // This is for zombie with ninja collision
        if (contact.bodyA.categoryBitMask == NinjaCategory) || (contact.bodyB.categoryBitMask == NinjaCategory) {
            
            //Impliments HighScore with User Defults
            let userDefaults = UserDefaults.standard
            let highScoreGlobal = UserDefaults().integer(forKey: "highScore")
            
            // Yeh yeh, Ends game... Changes scene and stops timer
            fingerOnNinja = false
            scene?.isPaused = true
            zombieTimer!.invalidate()
            gameTimer!.invalidate()
            
            
            // If score on this game is greater than previous highscore then update it
            if totalTime > highScoreGlobal {
                
                userDefaults.set(totalTime, forKey: "highScore")

            }
            //So i dont get multiple popup error
            
            if firstNinjaCollision == false {
            // Alert
            let winAlertController = UIAlertController(title: "You Died...  Your Score was \(totalTime)", message: nil, preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Okay", style: .destructive) { (alertAction) in
                self.resetGame()
            }
            winAlertController.addAction(dismissAction)
            view!.window!.rootViewController!.present(winAlertController, animated: true, completion: nil)
            firstNinjaCollision = true
            }
        }
        
    }
    
    
}

