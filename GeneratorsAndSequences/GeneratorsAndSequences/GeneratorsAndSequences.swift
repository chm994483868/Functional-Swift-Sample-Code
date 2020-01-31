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
        if element < 0 {
            return nil
        } else {
            
        }
    }
}
