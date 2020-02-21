//
//  GeneratorsAndSequences.swift
//  GeneratorsAndSequences
//
//  Created by HM C on 2020/1/31.
//  Copyright © 2020 HM C. All rights reserved.
//

import Foundation

//let xs = [1, 2, 3]
//for x in xs {
//    // do something with x
//}

// 一个生成器是每次根据请求生成数组新元素的 “过程” 。一个生成器可以是遵守以下协议的任何类型
protocol GeneratorType {
    associatedtype Element
    func next() -> Element?
}

class CountdownGenerator: GeneratorType {
    typealias Element = Int
    
    var element: Int
    
    init<T>(array: [T]) {
        element = array.count - 1
    }
    
    func next() -> Int? {
        let result = element < 0 ? nil : element
        element = element - 1
        
        return result
    }
}

func TEST_CountdownGenerator() {
    let xs = ["A", "B", "C"]
    
    let generator = CountdownGenerator(array: xs)
    while let i = generator.next() {
        print("Element \(i) of the array is \(xs[i])")
    }
}

class PowerGenerator: GeneratorType {
    typealias Element = NSDecimalNumber
    
    var power: NSDecimalNumber = 1
    let two: NSDecimalNumber = 2
    
    func next() -> NSDecimalNumber? {
        power = power.multiplying(by: two)
        return power
    }
}

extension PowerGenerator {
    func findPower(predicate: (NSDecimalNumber) -> Bool) -> NSDecimalNumber {
        while let x = next() {
            if predicate(x) {
                return x
            }
        }
        
        return 0
    }
}

func TEST_PowerGenerator() {
    var result = PowerGenerator().findPower { (decimalNumber) -> Bool in
        return decimalNumber.intValue > 1000
    }
    
    result = PowerGenerator().findPower(predicate: { $0.intValue > 1000 })
    
    print(result)
}

class FileLinesGenerator: GeneratorType {
    typealias Element = String
    
    var lines: [String] = []
    
    init(fileName: String) throws {
        let contents: String = try String(contentsOfFile: fileName)
        let newLine = NSCharacterSet.newlines
        lines = contents.components(separatedBy: newLine)
    }
    
    func next() -> String? {
        guard !lines.isEmpty else { return nil }
        let nextLine = lines.remove(at: 0)
        return nextLine
    }
}
