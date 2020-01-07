//
//  Immutability.swift
//  Immutability
//
//  Created by CHM on 2020/1/6.
//  Copyright © 2020 CHM. All rights reserved.
//

import Foundation

var x: Int = 1
let y: Int = 2

struct PointStruct {
    var x: Int
    var y: Int
}

class PointClass {
    var x: Int
    var y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

func setStructToOrigin(point: inout PointStruct) -> PointStruct {
    point.x = 0
    point.y = 0
    
    return point
}

func sum(xs: [Int]) -> Int {
    var result = 0
    for x in xs {
        result += x
    }
    
    return result
}
