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

func colorGenerator(color: NSColor) -> Filter {
    return { _ in
        guard let c = CIColor(color: color) else { fatalError("Failed to get `CIColor`") }
        let parameters = [kCIInputColorKey: c]
        
        guard let filter = CIFilter(name: "CIConstantColorGenerator", parameters: parameters) else { fatalError("`CIFilter` creation failed") }
        guard let outputImage = filter.outputImage else { fatalError("Failed to get `outputImage`") }
        
        return outputImage
    }
}
