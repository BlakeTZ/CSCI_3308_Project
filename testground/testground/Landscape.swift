//
//  Landscape.swift
//  testground
//
//  Created by 张勇昊 on 4/9/17.
//  Copyright © 2017 YonghaoZhang. All rights reserved.
//

import SpriteKit

class Landscape: SKNode {
    
    let ground: Ground
    let background: SKSpriteNode
    let contentNode: SKNode
    
    let size: CGSize
    
    
    // MARK: - Init
    
    init(size: CGSize){
        self.size = size
        let hue = CGFloat(arc4random() % 1000) / 1000
        background = SKSpriteNode(color: UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 0.5), size: CGSize(width: size.width, height: 4000))
        
        ground = Ground(size: CGSize(width: size.width, height: 60))
        
        contentNode = SKNode()
        
        super.init()
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Setup
    func setup() {
        addChild(background)
        background.anchorPoint = CGPoint(x: 0, y: 0)
        
        addChild(ground)
        ground.position.x = size.width / 2
        ground.position.y = ground.size.height / 2
        ground.zPosition = 1
        
        addChild(contentNode)
    }
    
    // MARK: - Helper Functions
    
    func resetLandscape() {
        background.color = randomColor()
        // other stuff to change the content of this landscape...
        contentNode.removeAllChildren()
        
        let n = arc4random() % 2
        
        switch n {
        case 0:
            // Create Coin
            let coin = Coin()
            contentNode.addChild(coin)
            
            coin.position.x = CGFloat(arc4random() % UInt32(size.width))
            coin.position.y = CGFloat(arc4random() % UInt32(size.height - 100)) + 40

            
        case 1:
            // Create Deadly
            let deadly = Deadly()
            contentNode.addChild(deadly)
            
            deadly.position.x = CGFloat(arc4random() % UInt32(size.width - deadly.size.width)) + deadly.size.width / 2
            deadly.position.y = 40 + deadly.size.height / 2
            
        default:
            break
        }
        
        
        
    }
    
    func randomColor() -> UIColor {
        let hue = CGFloat(arc4random() % 1000) / 1000
        return UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 0.5)
    }
    
}
