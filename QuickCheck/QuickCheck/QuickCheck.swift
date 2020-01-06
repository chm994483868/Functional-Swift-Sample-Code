//
//  QuickCheck.swift
//  QuickCheck
//
//  Created by HM C on 2020/1/4.
//  Copyright © 2020 HM C. All rights reserved.
//

import Foundation
import UIKit

func plusIsCommutative(_ x: Int, _ y: Int) -> Bool {
    return x + y == y + x
}

func minusIsCommutative(_ x: Int, _ y: Int) -> Bool {
    return x - y == y - x
}

//protocol Arbitrary {
//    static func arbitrary() -> Self // 返回的 Self 也就是实现了 Arbitrary 协议的这个类或者结构体的实例
//}

protocol Smaller {
    func smaller() -> Self?
}

protocol Arbitrary: Smaller {
    static func arbitrary() -> Self
}

extension Int: Arbitrary {
    static func arbitrary() -> Int { // 加 static 表示用遵守协议的类名(或结构体名、枚举名等) 调用协议方法
        return Int(arc4random())
    }
    
    func smaller() -> Int? { // 不加 static 表示用实例对象来调用协议方法
        return self == 0 ? nil : self / 2
    }
}

extension CGFloat: Arbitrary {
    static func arbitrary() -> CGFloat {
        return CGFloat(arc4random())
    }
    
    func smaller() -> CGFloat? {
        return self == 0 ? nil : self / 2
    }
}

let temporary = Int.arbitrary()

extension Character: Arbitrary {
    static func arbitrary() -> Character {
        return Character(UnicodeScalar(Int.random(from: 65, to: 90))!) // 大写字母 A-Z 的 ASCII 码
    }
    
    func smaller() -> Character? {
        return nil
    }
}

func tabulate<A>(times: Int, transform: (Int) -> A) -> [A] {
    return (0..<times).map(transform)
}

extension Int {
    static func random(from: Int, to: Int) -> Int {
        return from + (Int(arc4random()) % (to - from))
    }
}

extension String: Arbitrary {
    static func arbitrary() -> String {
        let randomLength = Int.random(from: 0, to: 40) // 随机生成一个 0 - 40 之间的数字，接着以该数字为长度随机生成一个字符串，字符串的每个字母为 A - Z 之间的随机一个
        let randomCharacter = tabulate(times: randomLength) { _ in
            Character.arbitrary()
        }
        
        return String(randomCharacter)
    }
}

let temporaryString = String.arbitrary()
let numberOfIterations = 100

func check1<A: Arbitrary>(message: String, _ property: (A) -> Bool) {
    for _ in 0..<numberOfIterations {
        let value = A.arbitrary()
        guard property(value) else {
            print("\"\(message)\" doesn't hold: \(value)")
            return
        }
        print("\"\(message)\" passed \(numberOfIterations) tests.")
    }
}

extension CGSize {
    var area: CGFloat {
        return width * height
    }
}

extension CGSize: Arbitrary {
    static func arbitrary() -> CGSize {
        return CGSize(width: CGFloat.arbitrary(), height: CGFloat.arbitrary())
    }
    
    func smaller() -> CGSize? {
        return nil
    }
}

//check1(message: <#T##String#>, <#T##property: (Arbitrary) -> Bool##(Arbitrary) -> Bool#>)

//check1(message: "Area should be at least 0") { (size: CGSize) in
//    size.area >= 0
//}

//check1(message: "Evary string starts with Hello") { (s: String) -> Bool in
//    s.hasPrefix("Hello")
//}

let temporaryInt = 100.smaller()

extension String: Smaller {
    func smaller() -> String? {
        return isEmpty ? nil : String(self.dropFirst())
    }
}

func iterateWhile<A>(condition: (A) -> Bool, initial: A, next: (A) -> A?) -> A {
    if let x = next(initial), condition(x)  {
        return iterateWhile(condition: condition, initial: x, next: next)
    }
    return initial
}

func check2<A: Arbitrary>(message: String, _ property: (A) -> Bool) {
    for _ in 0..<numberOfIterations {
        let value = A.arbitrary()
        guard property(value) else {
            let smallerValue = iterateWhile(condition: { !property($0) }, initial: value) { $0.smaller() }
            print("\"\(message)\" doesn't hold: \(smallerValue)")
            return
        }
    }
    
    print("\"\(message)\" passed \(numberOfIterations) tests.")
}

func qsort(_ originArray: [Int]) -> [Int] {
    if originArray.isEmpty { return [] }
    var array = originArray
    
    let pivot = array.remove(at: 0)
    let lesser = array.filter { $0 < pivot }
    let greater = array.filter { $0 >= pivot }
    
    return qsort(lesser) + [pivot] + qsort(greater)
}
