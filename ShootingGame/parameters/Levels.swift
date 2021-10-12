//
//  Levels.swift
//  ShootingGame
//
//  Created by דוד נוי on 12/10/2021.
//

import Foundation

class Levels {

    static var level = 1
    
    static func getLevel() -> Level{
        
        let level_1 = Level(level: 1, deads: 30, hearts: 3, monstersEnterTime: 1.0, minMonsterSpeed: 2.0, maxMonsterSpeed: 4)
        let level_2 = Level(level: 2, deads: 50, hearts: 3, monstersEnterTime: 0.8, minMonsterSpeed: 1.8, maxMonsterSpeed: 4)
        let level_3 = Level(level: 3, deads: 80, hearts: 3, monstersEnterTime: 0.6, minMonsterSpeed: 1.5, maxMonsterSpeed: 4.2)
        let level_4 = Level(level: 4, deads: 100, hearts: 4, monstersEnterTime: 0.4, minMonsterSpeed: 1.2, maxMonsterSpeed: 4.4)
        let level_5 = Level(level: 5, deads: 150, hearts: 4, monstersEnterTime: 0.2, minMonsterSpeed: 0.9, maxMonsterSpeed: 4.6)
        
        if level > 5 {
            level = 5
        }
        
        switch level {
        case 1:
            return level_1
        case 2:
            return level_2
        case 3:
            return level_3
        case 4:
            return level_4
        case 5:
            return level_5
        default:
            return level_1
        }
        
    }
}
