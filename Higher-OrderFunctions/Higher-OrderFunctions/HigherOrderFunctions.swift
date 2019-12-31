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

// Filter

let exampleFiles = ["README.md", "HelloWorld.swift", "FlappyBird.swift"]

func getSwiftFiles(_ files: [String]) -> [String] {
    var result: [String] = []
    for file in files {
        if file.hasSuffix(".swift") {
            result.append(file)
        }
    }
    
    return result
}

//_ = getSwiftFiles(exampleFiles)

extension Array {
    func filter(_ includeElement: (Element) -> Bool) -> [Element] {
        var result: [Element] = []
        for x in self where includeElement(x) {
            result.append(x)
        }
        
        return result
    }
}

func getSwiftFiles2(_ files: [String]) -> [String] {
    return files.filter { file in
        file.hasSuffix(".swift")
    }
}
                                                                                                        
// Reduce

func sum(_ xs: [Int]) -> Int { // 使用 Int 可能会很容易溢出
    var result: Int = 0
    for  x in xs {
        result += x
    }
    return result
}

func product(_ xs: [Int]) -> Int {
    var result: Int = 1
    for x in xs {
        result = x * result
    }
    return result
}

func concatenate(_ xs: [String]) -> String {
    var result: String = ""
    for x in xs {
        result += x
    }
    return result
}

func prettyPrintArray(_ xs: [String]) -> String {
    var result: String = "Entries in the array xs: \n"
    for x in xs {
        result = " " + result + x + "\n"
    }
    return result
}

extension Array {
    func reduce<T>(initial: T, combine: (T, Element) -> T) -> T {
        var result = initial
        for x in self {
            result = combine(result, x)
        }
        
        return result
    }
}

func sumUsingReduce(_ xs: [Int]) -> Int {
    return xs.reduce(initial: 0) { result, x in
        result + x
    }
}

func productUsingReduce(xs: [Int]) -> Int {
    return xs.reduce(initial: 1, combine: *)
}

func concatUsingReduce(xs: [String]) -> String {
    return xs.reduce(initial: "", combine: +)
}

func flatten<T>(xss: [[T]]) -> [T] {
    var result: [T] = []
    for xs in xss {
        result += xs
    }
    return result
}

func flattenUsingReduce<T>(xss: [[T]]) -> [T] {
    return xss.reduce(initial: []) { result, xs in
        result + xs
    }
}

extension Array {
    func mapUsingReduce<T>(transform: (Element) -> T) -> [T] {
        return reduce(initial: []) { result, x in
            return result + [transform(x)]
        }
    }
    
    func filterUsingReduce(includeElement: (Element) -> Bool) -> [Element] {
        return reduce(initial: []) { result, x in
            return includeElement(x) ? result + [x] : result
        }
    }
}
