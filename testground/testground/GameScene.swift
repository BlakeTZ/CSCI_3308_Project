//
//  GameScene.swift
//  testground
//
//  Created by 张勇昊 on 4/9/17.
//  Copyright © 2017 YonghaoZhang. All rights reserved.
//

import SpriteKit
import GameplayKit


struct Settings {
    struct Metrics {
        static let projectileRadius = CGFloat(10)
        static let projectileRestPosition = CGPoint(x: 120, y: 120)
        static let projectileTouchThreshold = CGFloat(10)
        static let projectileSnapLimit = CGFloat(10)
        static let forceMultiplier = CGFloat(0.5)
        static let rLimit = CGFloat(50)
    }
    struct Game {
        static let gravity = CGVector(dx: 0,dy: -4)
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var projectile: Projectile!
    //let projectile: projectile
    var projectileIsDragged = false
    var touchCurrentPoint: CGPoint!
    var touchStartingPoint: CGPoint!
    
    var hud:SKNode!
    
    let player: Player
    //let ground: Ground
    let cameraNode: SKCameraNode
    
    var landscapes = [Landscape]()
    
    //var touching: Bool = false
    
    let scoreLabel: SKLabelNode!
    var currentMaxX:Int!
    
    
    // MARK: - Init
    override init(size: CGSize){
        player = Player()
        //ground = Ground(size: size)
        cameraNode = SKCameraNode()
        
        scoreLabel = SKLabelNode(fontNamed: "Helvetica")
        
        currentMaxX = 120
        GameHandler.sharedInstance.score = 0
        
        
        
        let projectilePath = UIBezierPath(
            arcCenter: CGPoint.zero,
            radius: Settings.Metrics.projectileRadius,
            startAngle: 0,
            endAngle: CGFloat(M_PI * 2),
            clockwise: true
        )
        
        projectile = Projectile(path: projectilePath, color: UIColor.red, borderColor: UIColor.white)
        
        
        
        super.init(size: size)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    func setup() {
        physicsWorld.contactDelegate = self
        
        cameraNode.addChild(scoreLabel)
        
        scoreLabel.zPosition = 999
        scoreLabel.position.x = size.width / -2 + 10
        scoreLabel.position.y = size.height / 2 - 10
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.verticalAlignmentMode = .top
        scoreLabel.fontSize = 20
        scoreLabel.text = "0"
        
        addChild(player)
        player.position.x = size.width / 2
        player.position.y = size.height / 2
        player.zPosition = 2
        
        //addChild(ground)
        //ground.position.x = size.width / 2
        //ground.position.y = ground.size.height / 2
        
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position.x = size.width / 2
        cameraNode.position.y = size.height / 2
        
        addChild(projectile)
        projectile.position = Settings.Metrics.projectileRestPosition
        
        hud = SKNode()
        addChild(hud)

        
        for i in 0 ..< 2 {
            let landscape = Landscape(size: size)
            landscape.position.x = CGFloat(i) * size.width
            landscapes.append(landscape)
            addChild(landscape)
        }
        
    }
    
    
    override func didMove(to view: SKView) {
        
    }

    func fingerDistanceFromProjectileRestPosition(_ projectileRestPosition: CGPoint, fingerPosition: CGPoint) -> CGFloat {
        return sqrt(pow(projectileRestPosition.x - fingerPosition.x,2) + pow(projectileRestPosition.y - fingerPosition.y,2))
    }
    
    func projectilePositionForFingerPosition(_ fingerPosition: CGPoint, projectileRestPosition:CGPoint, circleRadius rLimit:CGFloat) -> CGPoint {
        let φ = atan2(fingerPosition.x - projectileRestPosition.x, fingerPosition.y - projectileRestPosition.y)
        let cX = sin(φ) * rLimit
        let cY = cos(φ) * rLimit
        return CGPoint(x: cX + projectileRestPosition.x, y: cY + projectileRestPosition.y)
    }

    
    // MARK: - TouchesBegan
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 50))
        func shouldStartDragging(_ touchLocation:CGPoint, threshold: CGFloat) -> Bool {
            let distance = fingerDistanceFromProjectileRestPosition(
                Settings.Metrics.projectileRestPosition,
                fingerPosition: touchLocation
            )
            return distance < Settings.Metrics.projectileRadius + threshold
        }
        
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            
            if !projectileIsDragged && shouldStartDragging(touchLocation, threshold: Settings.Metrics.projectileTouchThreshold)  {
                touchStartingPoint = touchLocation
                touchCurrentPoint = touchLocation
                projectileIsDragged = true
            }
        }
        
        
        //touching = true
    }
    
    
    // MARK: - TouchesMove
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if projectileIsDragged {
            if let touch = touches.first {
                let touchLocation = touch.location(in: self)
                let distance = fingerDistanceFromProjectileRestPosition(touchLocation, fingerPosition: touchStartingPoint)
                if distance < Settings.Metrics.rLimit  {
                    touchCurrentPoint = touchLocation
                } else {
                    touchCurrentPoint = projectilePositionForFingerPosition(
                        touchLocation,
                        projectileRestPosition: touchStartingPoint,
                        circleRadius: Settings.Metrics.rLimit
                    )
                }
                
            }
            projectile.position = touchCurrentPoint
        }
    }
    
    // MARK: - TouchesEnd
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if projectileIsDragged {
            projectileIsDragged = false
            let distance = fingerDistanceFromProjectileRestPosition(touchCurrentPoint, fingerPosition: touchStartingPoint)
            if distance > Settings.Metrics.projectileSnapLimit {
                let vectorX = touchStartingPoint.x - touchCurrentPoint.x
                let vectorY = touchStartingPoint.y - touchCurrentPoint.y
                projectile.physicsBody = SKPhysicsBody(circleOfRadius: Settings.Metrics.projectileRadius)
                projectile.physicsBody?.applyImpulse(
                    CGVector(
                        dx: vectorX * Settings.Metrics.forceMultiplier,
                        dy: vectorY * Settings.Metrics.forceMultiplier
                    )
                )
            } else {
                projectile.physicsBody = nil
                projectile.position = Settings.Metrics.projectileRestPosition
            }
        }
        
        
        
        //touching = false
    }
 
    // MARK: - Update
    
    var lastUpdateTime: CFTimeInterval = 0
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        var deltaTime = currentTime - lastUpdateTime
        if deltaTime > 1{
            deltaTime = 1 / 60
        }
        lastUpdateTime = currentTime
        
        if Int(projectile.position.x) > currentMaxX {
            GameHandler.sharedInstance.score += Int(projectile.position.x) - currentMaxX
            currentMaxX = Int(projectile.position.x)
            scoreLabel.text = "\(GameHandler.sharedInstance.score)"
            
        }
        
        
        //if touching {
        //    player.physicsBody?.applyForce(CGVector(dx: 0, dy: 200))
        //}
        
        //player.physicsBody!.velocity = CGVector(dx: 2800 * deltaTime, dy: 0)
        //player.position.x += 40 * CGFloat(deltaTime)
        //player.physicsBody?.applyForce(CGVector(dx: 10, dy: 0))
        
        /*
        if player.position.x >= (size.width / 2) {
            cameraNode.position.x = player.position.x
        }
        
        if player.position.y >= (size.height / 2) {
            cameraNode.position.y = player.position.y
        }
        */
        
        if projectile.position.x >= (size.width / 2) {
            cameraNode.position.x = projectile.position.x
        }
        
        if projectile.position.y >= (size.height / 2) {
            cameraNode.position.y = projectile.position.y
        }
        else {
            cameraNode.position.y = size.height / 2
        }
    
        
        if let projectileVelocity = projectile.physicsBody?.velocity {
            //let projectileAngleVlcity = projectile.physicsBody?.angularVelocity {
            if projectileVelocity.dx <= 50 && projectileVelocity.dy <= 50 {
                /*
                projectile.physicsBody?.affectedByGravity = false
                projectile.physicsBody?.velocity = CGVector(dx :0, dy: 0)
                projectile.physicsBody?.angularVelocity = 0
                projectile.zRotation = 0
                projectile.position = Settings.Metrics.projectileRestPosition
                cameraNode.position.x = size.width / 2
                cameraNode.position.y = size.height / 2
                */
                GameHandler.sharedInstance.saveGameStats()
                endGame()
                //goToGameScene()
            }
        }

        
        scrollLandscapes()
        
    }
    
    func scrollLandscapes(){
        for landscape in landscapes{
            let dx = landscape.position.x - cameraNode.position.x
            if dx < -(landscape.size.width + size.width / 2) {
                landscape.position.x += landscape.size.width * 2
                // reconfigure landscape
                landscape.resetLandscape()
            }
        }
    }
    
    
    // MARK: - Physics Delegate
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == PhysicsCategory.Coin | PhysicsCategory.Player {
            print("** Contact Player and Coin! **")
        }
        else if collision == PhysicsCategory.Deadly | PhysicsCategory.Player {
            print("** Contact Player and deadly, you are dead! **")
        }
        
    }
    /*
    func goToGameScene(){
        let gameScene: GameScene = GameScene(size: self.view!.bounds.size)
        let transition = SKTransition.fade(withDuration: 1)
        gameScene.scaleMode = SKSceneScaleMode.fill
        self.view!.presentScene(gameScene, transition: transition)
    }
    */
    func endGame(){
        GameHandler.sharedInstance.saveGameStats()
        
        let transtion = SKTransition.fade(withDuration: 1)
        let endGameScene = EndGame(size: self.size)
        self.view?.presentScene(endGameScene, transition: transtion)
    }
    
}
    
    
    

