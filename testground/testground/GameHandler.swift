//
//  GameHandler.swift
//  testground
//
//  Created by 张勇昊 on 4/11/17.
//  Copyright © 2017 YonghaoZhang. All rights reserved.
//

import Foundation

class GameHandler {
    var score:Int
    var highScore:Int
    var flowers:Int
    
    class var sharedInstance:GameHandler {
        struct Singleton {
            static let instance = GameHandler()
        }
        
        return Singleton.instance
    }
    
    init(){
        score = 0
        highScore = 0
        flowers = 0
        
        let userDefaults = UserDefaults.standard
        
        highScore = userDefaults.integer(forKey: "highScore")

    }
    
    func saveGameStats() {
        highScore = max(score,highScore)
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(highScore, forKey: "highScore")
        userDefaults.synchronize()
        
    }
}
