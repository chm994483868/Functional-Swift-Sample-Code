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

struct Order {
    let orderNumber: Int
    let person: Person?
}

struct Person {
    let name: String
    let address: Address?
}

struct Address {
    let streetName: String
    let city: String
    let state: String?
}


//switch madridPopulation {
//case 0?: print("Nobody in Madrid")
//case (1..<1000)?: print("Less than a million in Madrid")
//case .some(let x): print("\(x) people in Madrid")
//case .none: print("We don't know about Madrid")
//}

func populationDescriptionForCity(_ city: String) -> String? {
    guard let population = cities[city] else {
        return nil
    }
    
    return "The population of Madrid is \(population * 1000)"
}

//populationDescriptionForCity("Madrid")

func incrementOptional(_ optional: Int?) -> Int? {
    guard let x = optional else {
        return nil
    }
    
    return x + 1
}

func incrementOptional2(_ optional: Int?) -> Int? {
    return optional.map { $0 + 1 }
}

extension Optional {
    func map<U>(transform: (Wrapped) -> U) -> U? {
        guard let x = self else { return nil }
        
        return transform(x)
    }
}

//let x: Int? = 3
//let y: Int? = nil
//let z: Int? = x + y

func addOptionals(optionalX: Int?, optionalY: Int?) -> Int? {
    if let x = optionalX {
        if let y = optionalY {
            return x + y
        }
    }
    
    return nil
}

func addOptionals2(optionalX: Int?, optionalY: Int?) -> Int? {
    if let x = optionalX, let y = optionalY {
        return x + y
    }
    
    return nil
}

func addOptionals3(optionalX: Int?, optionalY: Int?) -> Int? {
    guard let x = optionalX, let y = optionalY else { return nil }
    
    return x + y
}

func addOptional4(optionalX: Int?, optionalY: Int?) -> Int? {
    return optionalX.flatMap { x in
        optionalY.flatMap { y in
            x + y
        }
    }
}

let capitals = [
    "France": "Paris",
    "Spain": "Madrid",
    "The Netherlands": "Amsterdam",
    "Belgium": "Brussels"
]

func populationOfCapital(_ country: String) -> Int? {
    guard let capital = capitals[country], let population = cities[capital] else {
        return nil
    }
    
    return population * 1000
}

func populationOfCapital1(_ country: String) -> Int? {
    return capitals[country].flatMap { capital in
        cities[capital].flatMap { population in
            return population * 1000
        }
    }
}

func populationOfCapital3(_ country: String) -> Int? {
    return capitals[country].flatMap { capital in
        return cities[capital]
    }.flatMap { population in
        return population * 1000
    }
}

extension Optional {
    func flatMap<U>(f: (Wrapped) -> U?) -> U? {
        guard let x = self else { return nil }
        
        return f(x)
    }
}
