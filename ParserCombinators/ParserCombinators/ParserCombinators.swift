//
//  ParserCombinators.swift
//  ParserCombinators
//
//  Created by HM C on 2020/2/24.
//  Copyright © 2020 HM C. All rights reserved.
//

import Foundation

struct Parser<Token, Result> {
    let p: (ArraySlice<Token>) -> AnySequence<(Result, ArraySlice<Token>)>
    //
    //    func parserA() -> Parser<Character, Character> {
    //
    //    }
    //
        func one<A>(x: A) -> AnySequence<A> {
            return AnySequence(GeneratorOfOne(x))
        }
    
    func none<T>() -> AnySequence<T> {
        return AnySequence(anyGenerator { nil } )
    }
    
    func parseA() -> Parser<Character, Character> {
        let a: Character = "a"
        
        //        return Parser { x in
        //            guard let (head, tail) = x.decompose, head == a else {
        //                return none()
        //            }
        //
        //            return one((a, tail))
        //            } as! Parser<Character, Character>
        
        return Parser { (x) -> AnySequence<(Result, ArraySlice<Token>)> in
            guard let (head, tail) = x.decompose, head == a else {
                return self.none()
            }
            
            return one(x: (a, tail))
        }
    }
}
    

func testParser<A>(parser: Parser<Character, A>, _ input: String) -> String {
    var result: [String] = []
    for (x, s) in parser.p(input.slice) {
        result += ["Success, found \(x), remainder: \(Array(s))"]
    }
    return result.isEmpty ? "Parsing failed." : result.joined(separator: "\n")
}
