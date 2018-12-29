//
//  UIImage+Merge.swift
//  voluxe-driver
//
//  Created by Christoph on 12/27/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {

    // Draws the specified image on top of the current image, returning
    // a new image.  If the specified image is nil or something goes wrong,
    // the original (self) image is returned.
    func draw(centered image: UIImage?, offset: CGPoint = CGPoint.zero) -> UIImage {
        guard let image = image else { return self }
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        self.draw(in: rect)
        let imageRect = CGRect(x: ((self.size.width - image.size.width) / 2) + offset.x,
                               y: ((self.size.height - image.size.height) / 2) + offset.y,
                               width: image.size.width,
                               height: image.size.height)
        image.draw(in: imageRect, blendMode: .normal, alpha: 1.0)
        let merged = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return merged ?? self
    }
}
