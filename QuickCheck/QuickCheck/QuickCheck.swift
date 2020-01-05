//
//  QuickCheck.swift
//  QuickCheck
//
//  Created by HM C on 2020/1/4.
//  Copyright © 2020 HM C. All rights reserved.
//

import Foundation

func plusIsCommutative(_ x: Int, _ y: Int) -> Bool {
    return x + y == y + x
}

func minusIsCommutative(_ x: Int, _ y: Int) -> Bool {
    return x - y == y - x
}

protocol Arbitrary {
    static func arbitrary() -> Self // 返回的 Self 也就是实现了 Arbitrary 协议的这个类或者结构体的实例
}

extension Int: Arbitrary {
    static func arbitrary() -> Int {
        return Int(arc4random())
    }
}

let temporary = Int.arbitrary()

extension Character: Arbitrary {
    static func arbitrary() -> Character {
        return UnicodeScalar(Int.random(form: 65, to: 90))
    }
}
