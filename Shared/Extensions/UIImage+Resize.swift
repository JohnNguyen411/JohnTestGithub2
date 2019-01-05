//
//  UIImage+Resize.swift
//  voluxe-driver
//
//  Created by Christoph on 1/4/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {

    /// Returns an image sized to the max specified dimension
    /// while also retaining the original image aspect ratio.
    /// If resizing fails, nil is returned.
    func resized(to dimension: CGFloat) -> UIImage? {
        let max = fmax(self.size.width, self.size.height)
        let scale = dimension / max
        let size = self.size.applying(CGAffineTransform(scaleX: scale, y: scale))
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let scaled = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaled
    }
}
