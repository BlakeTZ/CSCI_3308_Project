//
//  Nodes.swift
//  testground
//
//  Created by 张勇昊 on 4/9/17.
//  Copyright © 2017 YonghaoZhang. All rights reserved.
//

import SpriteKit

class Projectile: SKShapeNode {
    convenience init(path: UIBezierPath, color: UIColor, borderColor:UIColor) {
        self.init()
        self.path = path.cgPath
        self.fillColor = color
        self.strokeColor = borderColor
    }
}
