//
//  UIView+Dimensions.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 2/15/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    public static func onePx() -> CGFloat {
        return (1.0 / UIScreen.main.scale)
    }
}
