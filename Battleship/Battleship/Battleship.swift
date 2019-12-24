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

typealias Region = (Position) -> Bool

// 以原点为圆心的圆
func circle(_ radius: Distance) -> Region {
    return { point in point.length <= radius }
}

func circle2(_ radius: Distance, _ center: Position) -> Region {
    return { point in point.minus(center).length <= radius }
}

func shift(region: @escaping Region, offset: Position) -> Region {
    return { point in region(point.minus(offset)) }
}

// 表示圆心是 (5, 5) 半径为 10 的圆
// 首先传入参数 circle(10) 表示圆心在原点半径为 10 的圆， 后面其实是任意一点与 (5, 5) 的距离，与 10 这个半径做比较。
let temp = shift(region: circle(10), offset: Position(x: 5, y: 5))

// 由原区域以外的所有点组成
func invert(_ region: @escaping Region) -> Region {
    return { point in !region(point) }
}

//let temp = circle(radius: 5)
//let isCircle = temp(Position(x: 3, y: 2))
// 判断 x: 3 y: 2 的 Position 是否在原点是圆心半径是 5 的圆内
let isCircle = circle(5)(Position(x: 3, y: 2))

// 两个区域的交集（用 && 连接）
func intersection(_ region1: @escaping Region, _ regior2: @escaping Region) -> Region {
    return { point in region1(point) && regior2(point) }
}

// 两个区域的并集（用 || 连接）
func union(_ region1: @escaping Region, _ region2: @escaping Region) -> Region {
    return { point in region1(point) || region2(point) }
}

/// 所有在第一个区域中且不在第二个区域中的点构建一个新的区域
/// - Parameters:
///   - region: 第一个区域
///   - minus: 要被剪去的第二个区域
func difference(_ region: @escaping Region, _ minus: @escaping Region) -> Region {
    return intersection(region, invert(minus))
}
