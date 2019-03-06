//
//  UIImage+Orientation.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 2/21/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func imageAngle() -> Double {
        if self.imageOrientation == .up {
            return Double.pi / 2
        } else if self.imageOrientation == .right || self.imageOrientation == .left {
            return -Double.pi / 2
        }
        else {
            return 0
        }
    }
}
