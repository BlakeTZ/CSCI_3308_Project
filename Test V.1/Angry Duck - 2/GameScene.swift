//
//  GameScene.swift
//  Angry Duck - 2
//
//  Created by yuma@duck on 7/11/16.
//  Copyright © 2016 yuma@duck. All rights reserved.
//

// UPDATE: Boxes now reset. You can see how I did it by looking at the comments below

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var duck: SKSpriteNode!
    
    var originalDuckPos: CGPoint!
    var hasGone = false
    
    
    override func didMove(to view: SKView) {
        duck = childNode(withName: "duck") as! SKSpriteNode
        originalDuckPos = duck.position
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !hasGone {
            if let touch = touches.first {
                let touchLocation = touch.location(in: self)
                let touchedWhere = nodes(at: touchLocation)
                
                if !touchedWhere.isEmpty {
                    for node in touchedWhere {
                        if let sprite = node as? SKSpriteNode {
                            if sprite == duck {
                                duck.position = touchLocation
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !hasGone {
            if let touch = touches.first {
                let touchLocation = touch.location(in: self)
                let touchedWhere = nodes(at: touchLocation)
                
                if !touchedWhere.isEmpty {
                    for node in touchedWhere {
                        if let sprite = node as? SKSpriteNode {
                            if sprite == duck {
                                duck.position = touchLocation
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !hasGone {
            if let touch = touches.first {
                let touchLocation = touch.location(in: self)
                let touchedWhere = nodes(at: touchLocation)
                
                if !touchedWhere.isEmpty {
                    for node in touchedWhere {
                        if let sprite = node as? SKSpriteNode {
                            if sprite == duck {
                                let dx = -(touchLocation.x - originalDuckPos.x)
                                let dy = -(touchLocation.y - originalDuckPos.y)
                                let impulse = CGVector(dx: dx, dy: dy)
                
                                duck.physicsBody?.applyImpulse(impulse)
                                duck.physicsBody?.applyAngularImpulse(-0.01)
                                duck.physicsBody?.affectedByGravity = true
                                
                                hasGone = true
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let duckPhysicsBody = duck.physicsBody {
            if duckPhysicsBody.velocity.dx <= 0.1 && duckPhysicsBody.velocity.dy <= 0.1 && duckPhysicsBody.angularVelocity <= 0.1 && hasGone {
                duck.physicsBody?.affectedByGravity = false
                duck.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                duck.physicsBody?.angularVelocity = 0
                duck.zRotation = 0
                duck.position = originalDuckPos
                
                hasGone = false
                }
            }
    }
}
