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

class LimitGenerator<G: GeneratorType>: GeneratorType {
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

//extension Int {
//    func countDown() -> AnyGenerator<Int> {
//        var i = self
//        return anyGenerator { i < 0 ? nil : i-- }
//    }
//}

//func +<G: GeneratorType, H: GeneratorType>( first: inout G, second: inout H) -> AnyGenerator<G.Element> where G.Element == H.Element {
//    return anyGenerator { first.next() ?? second.next()}
//}

protocol SequenceType {
    associatedtype Generator: GeneratorType
    func generate() -> Generator
    
    func map<T>(transform: (Self.Generator.Element) throws -> T) rethrows -> [T]
    func filter(includeElement: (Self.Generator.Element) throws -> Bool) rethrows -> [Self.Generator.Element]
}

struct ReverseSequence<T>: SequenceType {
    func map<T>(transform: (Int) throws -> T) rethrows -> [T] {
        let generator = self.generate()
        var arr = [T]()
        while let i = generator.next() {
            let temp = try? transform(i)
            if temp != nil {
                arr.append(temp!)
            }
        }
        return arr
    }
    
    func filter(includeElement: (Int) throws -> Bool) rethrows -> [Int] {
        let generator = self.generate()
        var arr = [Int]()
        while let i = generator.next() {
            let temp = try? includeElement(i)
            if temp != nil {
                arr.append(i)
            }
        }
        return arr
    }
    
    var array: [T]
    
    init(array: [T]) {
        self.array = array
    }
    
    func generate() -> CountdownGenerator {
        return CountdownGenerator(array: array)
    }
}

func TEST_ReverseSequence() {
    let xs = [1, 2, 3]
    let reverseSequence = ReverseSequence(array: xs)
    let reverseGenerator = reverseSequence.generate()
    while let i = reverseGenerator.next() {
        print("Index \(i) is \(xs[i])")
    }
    
    _ = ReverseSequence(array: xs).map { xs[$0] }
}

extension SequenceType {
//    public func map<T>(@noescape transform: (Self.Generator.Element) throws -> T) rethrows -> [T]
//    public func filter(@noescape includeElement: (Self.Generator.Element) throws -> Bool) rethrows -> [Self.Generator.Element]
}

// 10.5 不止是 Map 与 Filter
//struct AnySequence<Element>: SequenceType {
//    init<G: GeneratorType>(_ makeUnderlyingGenerator: () -> G) where G.Element == Element {
//        //
//    }
//
//    func generate() -> AnyGenerator<Element> {
//        //
//    }
//}
