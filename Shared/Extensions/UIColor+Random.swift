//
//  UIColor+Random.swift
//  voluxe-driver
//
//  Created by Christoph on 11/19/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

    func image(size: CGSize = CGSize(width: 32, height: 32)) -> UIImage {
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = UIScreen.main.scale
        return UIGraphicsImageRenderer(size: size, format: format).image {
            rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
    }

    static func random() -> UIColor {
        let r: CGFloat = CGFloat(arc4random() % 256) / 256
        let g: CGFloat = CGFloat(arc4random() % 256) / 256
        let b: CGFloat = CGFloat(arc4random() % 256) / 256
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}
