//
//  ViewController.swift
//  EncapsulationCoreImage
//
//  Created by HM C on 2019/12/26.
//  Copyright © 2019 HM C. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let url = URL(string: "https://mmbiz.qpic.cn/mmbiz_jpg/3KdVYnhMr1woVgVM0VHIeMwH6WyIoK01PZicvjlz0yBrn8Je4s9X9v745OliaVicibR5QlD3cr17QjWfI0qGViarwQQ/640?wx_fmt=jpeg&wxfrom=5&wx_lazy=1&wx_co=1")
        guard let image = CIImage(contentsOf: url!) else {
            fatalError("image is nil")
        }

        let imgView = UIImageView(frame: CGRect(x: 0, y: 44, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width * 1532 / 1080.0))
//        imgView.image = UIImage(ciImage: image)
        view.addSubview(imgView)

        let blurRadius = 5.0

        let overlayColor = UIColor.red.withAlphaComponent(0.2)
        let overlay = colorGenerator(color: overlayColor)(image) // print(UIImage(ciImage: overlay)) <UIImage:0x600002c4b060 anonymous {1.7976931348623157e+308, 1.7976931348623157e+308}>
        let blurredImage = blur(blurRadius)(image)
        let overlaidImage = colorOverlay(overlayColor)(blurredImage)
        let result = colorOverlay(overlayColor)(blur(blurRadius)(image))
        let result2 = composeFilters(blur(blurRadius), colorOverlay(overlayColor))(image)

        let result3 = (blur(blurRadius) >>> colorOverlay(overlayColor))(image)
    }


}

