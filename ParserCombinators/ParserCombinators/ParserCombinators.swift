//
//  ParserCombinators.swift
//  ParserCombinators
//
//  Created by HM C on 2020/2/24.
//  Copyright © 2020 HM C. All rights reserved.
//

import Foundation

struct Parser<Token, Result> {
    let p: ArraySlice<Token> -> AnySequence<(Result, ArraySlice<Token>)>
    
    func parserA() -> Parser<Character, Character> {
        
    }
    
    func one<A>(x: A) -> AnySequence<A> {
        return AnySequence(GeneratorOfOne(x))
    }
}
    
