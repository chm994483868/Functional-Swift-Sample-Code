//
//  HigherOrderFunctions.swift
//  Higher-OrderFunctions
//
//  Created by HM C on 2019/12/30.
//  Copyright © 2019 HM C. All rights reserved.
//

import Foundation

func incrementArray(xs: [Int]) -> [Int] {
    var result: [Int] = []
    for x in xs {
        result.append(x + 1)
    }
    
    return result
}

func doubleArray1(xs: [Int]) -> [Int] {
    var result: [Int] = []
    for x in xs {
        result.append(x * 2)
    }
    
    return result
}

func computeIntArray(xs: [Int], transform: (Int) -> Int) -> [Int] {
    var result: [Int] = []
    for x in xs {
        result.append(transform(x))
    }
    
    return result
}

func doubleArray2(xs: [Int]) -> [Int] {
    return computeIntArray(xs: xs, transform: { x in x * 2 })
}

//func isEvenArray(xs: [Int]) -> [Bool] {
//    return computeIntArray(xs: xs, transform: { x in x % 2 == 0 })
//}

func computeBoolArray(xs: [Int], transform: (Int) -> Bool) -> [Bool] {
    var result: [Bool] = []
    
    for x in xs {
        result.append(transform(x))
    }
    
    return result
}

func genericComputeArray1<T>(xs: [Int], transform: (Int) -> T) -> [T] {
//    var result: [T] = []
//
//    for x in xs {
//        result.append(transform(x))
//    }
//
//    return result
    
//    return map(xs: xs, transform: transform)
    return xs.map(transform: transform)
}

func map<Element, T>(xs: [Element], transform: (Element) -> T) -> [T] {
    var result: [T] = []
    
    for x in xs {
        result.append(transform(x))
    }
    
    return result
}

extension Array {
    func map<T>(transform: (Element) -> T) -> [T] {
        var result: [T] = []
        
        for x in self {
            result.append(transform(x))
        }
        
        return result
    }
}
