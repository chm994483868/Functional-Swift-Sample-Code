//
//  EncapsulationCoreImage.swift
//  EncapsulationCoreImage
//
//  Created by HM C on 2019/12/26.
//  Copyright © 2019 HM C. All rights reserved.
//

import UIKit
import Foundation
import CoreImage

typealias Filter = (CIImage) -> CIImage

func blur(_ radius: Double) -> Filter {
    return { image in
        let parameters = [kCIInputRadiusKey: radius,
                          kCIInputImageKey: image] as [String : Any]
        
        guard let filter = CIFilter(name: "CIGaussianBlur", parameters: parameters) else { fatalError("CIFilter(name:, parameters:) 执行错误") }
        guard let outputImage = filter.outputImage else { fatalError("filter.outputImage 为 nil") }
        
        return outputImage
    }
}

func colorGenerator(color: UIColor) -> Filter {
    return { _ in
        let c = CIColor(color: color)
        let parameters = [kCIInputColorKey: c]
        
        guard let filter = CIFilter(name: "CIConstantColorGenerator", parameters: parameters) else { fatalError("`CIFilter` creation failed") }
        guard let outputImage = filter.outputImage else { fatalError("Failed to get `outputImage`") }
        
        return outputImage
    }
}

func compositeSourceOver(_ overlay: CIImage) -> Filter {
    return { image in
        let parameters = [kCIInputBackgroundImageKey: image,
                          kCIInputImageKey: overlay]
        guard let filter = CIFilter(name: "CISourceOverCompositing", parameters: parameters) else { fatalError("`CIFilter` creation failed") }
        guard let outputImage = filter.outputImage else { fatalError("Failed to get `outputImage`") }
        
//        let cropRect = image.extent
//        return outputImage.imageCroppingToRect(cropRect)
        
        return outputImage
    }
}

func colorOverlay(_ color: UIColor) -> Filter {
    return { image in
        let overly = colorGenerator(color: color)(image)
        return compositeSourceOver(overly)(image)
    }
}

func composeFilters(_ filter1: @escaping Filter, _ filter2: @escaping Filter) -> Filter {
    return { image in return filter2(filter1(image)) }
}

infix operator >>>

func >>>(_ filter1: @escaping Filter, _ filter2: @escaping Filter) -> Filter {
    return { image in filter2(filter1(image)) }
}

func add1(_ x: Int, _ y: Int) -> Int {
    return x + y
}

func add2(_ x: Int) -> (Int) -> Int {
    return { y in
        return x + y
    }
}

let tt = add1(1, 2)
let tt2 = add2(1)(2)

func add3(_ x: Int) -> (Int) -> Int {
    return { y in x + y }
}
