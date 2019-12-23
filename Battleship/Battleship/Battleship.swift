//
//  Battleship.swift
//  Battleship
//
//  Created by HM C on 2019/12/24.
//  Copyright © 2019 HM C. All rights reserved.
//

import Foundation

typealias Distance = Double

struct Position {
    var x: Double
    var y: Double
}

extension Position {
    func inRange(_ range: Distance) -> Bool {
        sqrt(x * x + y * y) <= range
    }
}

struct Ship {
    var position: Position
    var firingRange: Distance
    var unsafeRange: Distance
}

extension Ship {
    func canEngageShip(_ target: Ship) -> Bool {
        let dx = target.position.x - position.x
        let dy = target.position.y - position.y
        let targetDistance = sqrt(dx * dx + dy * dy)
        return targetDistance <= firingRange && targetDistance > unsafeRange
    }
}

extension Ship {
    func canSafelyEngageShip1(_ target: Ship, _ friendly: Ship) -> Bool {
        let dx = target.position.x - position.x
        let dy = target.position.y - position.y
        
        let targetDistance = sqrt(dx * dx + dy * dy)
        
        let friendlyDx = friendly.position.x - target.position.x
        let friendlyDy = friendly.position.y - target.position.y
        
        let friendlyDistance = sqrt(friendlyDx * friendlyDx + friendlyDy * friendlyDy)
        
        return targetDistance <= firingRange && targetDistance > unsafeRange && friendlyDistance > friendly.unsafeRange
    }
    
    func canSafelyEngageShip2(_ target: Ship, _ friendly: Ship) -> Bool {
        let targetDistance = target.position.minus(position).length
        let friendlyDistance = friendly.position.minus(target.position).length
        
        return targetDistance >= firingRange && targetDistance > unsafeRange && friendlyDistance > friendly.unsafeRange
    }
}

extension Position {
    func minus(_ p: Position) -> Position {
        Position(x: x - p.x, y: y - p.y)
    }
    
    var length: Double {
        sqrt(x * x + y * y)
    }
}
