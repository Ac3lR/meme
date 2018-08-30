//
//  GameScene.swift
//  Zombie Dodger
//
//  Created by Axel Raut on 1/8/18.
//  Copyright © 2018 Canberra Grammar School. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    var NinjaCategory: UInt32 = 0x1 << 0
    var ZombieCategory: UInt32 = 0x1 << 1
    var BottomCategory: UInt32 = 0x1 << 2
    
    var gameStart: Bool = true

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
//    var timerCreated: Bool = false
    
    override func didMove(to view: SKView) {

            spawnZombies()
                
                let ninjaTexture = SKTexture(imageNamed: "ninja")
                
                ninjaNode = SKSpriteNode(texture: ninjaTexture, size: CGSize(width: 175, height: 175))
                ninjaNode?.position = CGPoint(x: 0, y: -500)
                ninjaNode?.physicsBody = SKPhysicsBody(texture: ninjaTexture, size: CGSize(width: 175, height: 175))
                ninjaNode!.physicsBody!.isDynamic = false
                ninjaNode?.name = "ninjaNode"
                ninjaNode?.physicsBody!.categoryBitMask = NinjaCategory
                ninjaNode!.physicsBody!.contactTestBitMask = ZombieCategory
        
                addChild(ninjaNode!)
        
        
        
                let bottomLeftPoint = CGPoint(x: -(size.width / 2), y: -700)
                let bottomRightPoint = CGPoint(x: size.width / 2, y: -700)
        
                // Bottom node
                let bottomNode = SKNode()
                bottomNode.physicsBody = SKPhysicsBody(edgeFrom: bottomLeftPoint, to: bottomRightPoint)
                bottomNode.physicsBody!.categoryBitMask = BottomCategory
                addChild(bottomNode)
        
        
        
                timerNode = SKLabelNode(fontNamed: "Chalkduster")
                timerNode!.text = "Your Score:"
                timerNode!.fontSize = 65
                timerNode!.fontColor = SKColor.green
                timerNode!.position = CGPoint(x: -300, y: 600)
                
                addChild(timerNode!)
        
                lvlNode = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
                lvlNode!.text = "Level 1"
                lvlNode!.fontSize = 50
                lvlNode!.color = UIColor.white
                lvlNode!.position = CGPoint(x: -350, y: 550)
        
                addChild(lvlNode!)
        
        
                physicsWorld.contactDelegate = self

                physicsWorld.gravity = CGVector(dx: 0, dy: gravity)
        
                gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (theTimer) in
                    self.totalTime += 1
                    self.timerNode!.text = "Your Score: \(self.totalTime)"
                    
                    if self.totalTime % 20 == 0 && self.lvl < 5 {
                        
                        self.lvl += 1
                        
                        self.lvlNode!.text = "Level \(self.lvl)"
                        
                    }
                    
                })
        
                zombieTimerFunc()
        
        
    
        

    }
    
  
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let touchLocation = touch.location(in: self)
        let touchedNode = atPoint(touchLocation)
        
        
        
            
            
            
        
        
        if touchedNode.name == "ninjaNode" {
            fingerOnNinja = true

        }
        
        
        
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let touchLocation = touch.location(in: self)
        
        if fingerOnNinja == true {
            
        ninjaNode!.position = touchLocation
            
        }
        
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if fingerOnNinja == true {
            fingerOnNinja = false
        }
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
    
        
        
    }

    
    func spawnZombies() {
        print("hasagi")
        var zombieSpawnX = 0
        let randomZombie = Int(arc4random_uniform(4)) + 1
        
        
        let zombieTexture = SKTexture(imageNamed: "zombie\(randomZombie)")
        let zombieNode = SKSpriteNode(texture: zombieTexture, size: CGSize(width: 150, height: 150))
        zombieNode.physicsBody = SKPhysicsBody(texture: zombieTexture, size: CGSize(width: 150, height: 150))
        zombieNode.physicsBody!.categoryBitMask = ZombieCategory
        zombieNode.physicsBody!.contactTestBitMask = BottomCategory
        zombieNode.physicsBody!.allowsRotation = false
        
        print("hasagi2")
        zombieSpawnX = Int(arc4random_uniform(750)) - 375
        zombieNode.position = CGPoint(x: zombieSpawnX, y: 850)
        addChild(zombieNode)
        
        
        
    }

    
    func zombieTimerFunc() {
        
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
        
        if (contact.bodyA.categoryBitMask == BottomCategory) {

           contact.bodyB.node!.removeFromParent()

        }
        
        if (contact.bodyB.categoryBitMask == BottomCategory) {
            
            contact.bodyA.node!.removeFromParent()
            
        }
        
        
        if (contact.bodyA.categoryBitMask == NinjaCategory) || (contact.bodyB.categoryBitMask == NinjaCategory) {


            
            
            
        }
        
    }
    
    
}

