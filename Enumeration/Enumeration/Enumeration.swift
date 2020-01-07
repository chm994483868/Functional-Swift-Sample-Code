//
//  Enumeration.swift
//  Enumeration
//
//  Created by CHM on 2020/1/7.
//  Copyright © 2020 CHM. All rights reserved.
//

import Foundation

//enum NSStringEncoding {
//    NSASCIIStringEncoding = 1,
//    NSNEXTSTEPStringEncoding = 2,
//    NSJapaneseEUCStringEncoding = 3,
//    NSUTF8StringEncoding = 4,
//}

// Swift 函数式编程的一条核心原则：高效的利用类型排除程序缺陷。

enum Encoding {
    case ASCII
    case NEXTSTEP
    case JapaneseEUD
    case UTF8
}

//extension Encoding {
//    var nsStringEncoding: NSStringEncoding {
//        switch self {
//        case .ASCII: return NSASCIIStringEncoding
//        case .NEXTSTEP: return NSNEXTSTEPStringEncoding
//        case .JapaneseEUD: return NSJapaneseEUCStringEncoding
//        case .UTF8: return NSUTF8StringEncoding
//        }
//    }
//}

//extension Encoding {
//    init?(enc: NSStringEncoding) {
//        switch enc {
//        case NSASCIIStringEncoding: self = .ASCII
//        case NSNEXTSTEPStringEncoding: self = .NEXTSTEP
//        case NSJapaneseEUCStringEncoding: self = .JapaneseEUD
//        case NSUTF8StringEncoding: self = .UTF8
//        default: return nil
//        }
//    }
//}

enum LookUpError: Error {
    case CapitalNotFound
    case PopulationNotFound
}

enum PopulationResult {
    case Success(Int)
    case Error(LookUpError)
}

//func populationOfCapital(country: String) -> PopulationResult {
//    guard let capital = capital[country] else {
//        return .Error(.CapitalNotFound)
//    }
//
//    guard let population = cities[capital] else {
//        return .Error(.PopulationNotFound)
//    }
//
//    return .Success(population)
//}

//switch populationOfCapital(country: "France") {
//case let .Success(population):
//    print("France's capital has \(population) thousand inhabitants")
//case let .Error(error):
//    print("Error: \(error)")
//}

let mayors = [
    "Paris": "Hidalgo",
    "Madrid": "Carmena",
    "Amsterdam": "van der Laan",
    "Berlin": "Muller"
]

//func mayorOfCapital(country: String) -> String? {
//    return capital[country].flatMap { mayors[$0] }
//}

enum Result<T> {
    case Success(T)
    case Error(Error)
}

//func populationOfCapital(country: String) -> Result<Int> {
//    //
//}
//
//func mayorOfCapital(country: String) -> Result<String> {
//    //
//}

//func populationOfCapital(country: String) throws -> Int {
//    guard let capital = capitals[country] else {
//        throw LookUpError.CapitalNotFound
//    }
//
//    guard let population = cities[capital] else {
//        throw LookUpError.PopulationNotFound
//    }
//
//    return population
//}
//
//do {
//    let population = try populationOfCapital(country: "France")
//    print("France's population is \(population)")
//} catch {
//    print("Lookup error: \(error)")
//}

enum Optional<T> {
    case None
    case Some(T)
}

func ??<T>(result: Result<T>, handleError: (Error) -> T) -> T {
    switch result {
    case let .Success(value):
        return value
    case let .Error(error):
        return handleError(error)
    }
}

enum Add<T, U> {
    case InLeft(T)
    case InRight(U)
}

