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
