//
//  Optoinal.swift
//  Optional
//
//  Created by HM C on 2020/1/2.
//  Copyright © 2020 HM C. All rights reserved.
//

import Foundation

let cities = ["Paris": 2241, "Madrid": 3165, "Amsterdam": 827, "Berlin": 3562]

//let madridPopulation: Int = cities["Madrid"]
let madridPopulation: Int? = cities["Madrid"]


//if madridPopulation != nil {
//    print("The population of Madrid is \(madridPopulation! * 1000)")
//} else {
//    print("Unknown city: Madrid")
//}
//
//if let madridPopulation = cities["Madrid"] {
//    print("The population of Madrid is \(madridPopulation * 1000)")
//} else {
//    print("Unknown city: Madrid")
//}

infix operator ??
func ??<T>(optional: T?, defaultValue: T) -> T {
    if let x = optional {
        return x
    } else {
        return defaultValue
    }
}

func ??<T>(optional: T?, defaultValue: () -> T) -> T {
    if let x = optional {
        return x
    } else {
        return defaultValue() // 闭包执行
    }
}

//myOptional ?? { myDefaultValue }

//infix operator ?? { associativity right precedence 110 }
//func ??<T>(optional: T?, @autoclosure defaultValue: () -> T) -> T {
//    if let x = optional {
//        return x
//    } else {
//        return defaultValue()
//    }
//}
