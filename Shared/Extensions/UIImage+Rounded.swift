//
//  UIImage+Round.swift
//  voluxe-driver
//
//  Created by Christoph on 12/23/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {

    // if fails returns original image
    func rounded(cornerRadius: CGFloat, resizable: Bool = false) -> UIImage {
        let rect = CGRect(origin: CGPoint.zero, size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1)
        UIBezierPath(roundedRect: rect,
                     cornerRadius: cornerRadius).addClip()
        self.draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        if !resizable {
            return image ?? self
        } else {
            let insets = UIEdgeInsets(top: cornerRadius, left: cornerRadius, bottom: cornerRadius, right: cornerRadius)
            return image?.resizableImage(withCapInsets: insets) ?? self
        }
    }
}
