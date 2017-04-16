//
//  ground.swift
//  testground
  import SpriteKit

class Ground: SKSpriteNode {
  
    init(size: CGSize){
        let groundSize = CGSize(width: size.width, height: 40)
        
        super.init(texture: nil, color: UIColor.brown, size: groundSize)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


     func setup() {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody!.isDynamic = false
        physicsBody!.categoryBitMask = PhysicsCategory.Ground
        physicsBody!.collisionBitMask = PhysicsCategory.Player
        physicsBody!.contactTestBitMask = PhysicsCategory.None
    }

}
