//
//  GeneratorsAndSequences.swift
//  GeneratorsAndSequences
//
//  Created by HM C on 2020/1/31.
//  Copyright © 2020 HM C. All rights reserved.
//

import Foundation

//for x in xs {
//    // do something with x
//}

protocol GeneratorType {
    associatedtype Element
    func next() -> Element?
}

class CountdownGenerator: GeneratorType {
    typealias Element = Int
    var element: Int
    
    init<T>(array: [T]) {
        self.element = array.count - 1
    }
    
    func next() -> Int? {
        let temporaryValue = element
        if temporaryValue < 0 {
            return nil
        } else {
            element = element - 1
        }
        
        return temporaryValue
    }
}

//let xs = ["A", "B", "C"]
//let generator = CountdownGenerator(array: xs)
//while let i = generator.next() {
//    print("Element \(i) of the array is \(xs[i])")
//}

// 生成器却封装了数组序列值的计算。如果你想要用另外一种方式排序序列值，我们只需要更新生成器，而不必再修改这里的代码。
// 某些情况下，生成器并不需要生成 nil 值。

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

//PowerGenerator().findPower { $0.intValue > 1000 }

class FileLinesGenerator: GeneratorType {
    typealias Element = String
    
    var lines: [String] = []
    
    init(filename: String) throws {
        let contents: String = try String(contentsOfFile: filename)
        
        let newLine = NSCharacterSet.newlines
        lines = contents.components(separatedBy: newLine)
    }
    
    func next() -> String? {
        guard !lines.isEmpty else { return nil }
        let nextLine = lines.remove(at: 0) // 每次删除并返回第一行字符串
        return nextLine
    }
}

extension GeneratorType {
    mutating func find(predicate: (Element) -> Bool) -> Element? {
        while let x = self.next() {
            if predicate(x) {
                return x
            }
        }
        
        return nil
    }
}

class LimitGenerator<G: GeneratorType>: GeneratorType {
    typealias Element = G.Element
    
    var limit = 0
    var generator: G
    
    init(limit: Int, generator: G) {
        self.limit = limit
        self.generator = generator
    }
    
    func next() -> G.Element? {
        guard limit >= 0 else { return nil }
        limit = limit - 1
        return generator.next()
    }
}

//class AnyGenerator<Element>: GeneratorType, Sequence {
//    init(next: () -> Element?) {
//
//    }
//}

//extension Int {
//    func countDown() -> AnyGenerator<Int> {
//        var i = self
//        return anyGenerator { i < 0 ? nil : i-- }
//    }
//}

//func +<G: GeneratorType, H:GeneratorType>(first: inout G, second: inout H) -> AnyGenerator<G.Element> where G.Element == H.Element {
//    return anyGenerator { first.next() ?? second.next() }
//}

protocol SequenceType {
    associatedtype Generator: GeneratorType
    func generate() -> Generator
}

struct ReverseSequence<T>: SequenceType {
    var array: [T]
    
    init(array: [T]) {
        self.array = array
    }
    
    func generate() -> some GeneratorType {
        <#code#>
    }
}
