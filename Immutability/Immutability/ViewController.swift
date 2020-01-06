//
//  ViewController.swift
//  Immutability
//
//  Created by CHM on 2020/1/6.
//  Copyright © 2020 CHM. All rights reserved.
//

import UIKit

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

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let pointClass = PointClass(x: 1, y: 1)
        
        let temp = setClassToOrigin(point: pointClass)
        
        print(pointClass)
        print(temp)
    }
    
    func setClassToOrigin(point: PointClass) -> PointClass {
        point.x = 0
        point.y = 0
        
        return point
    }
}

