//
//  Colors.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/2/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

    // MARK:- Color constants

    // more condensed method to declare a color constant and more
    // consistent with how UIColor declares its constants
    static let luxeBlurTint = UIColor(hex6: 0xf1f1e0, alpha: 0.3)

    // MARK: - Color Scheme
    
    public class func luxeWhite() -> UIColor { return .white }
    public class func luxeLightOrange() -> UIColor { return UIColor("#FBEEE9") }
    public class func luxeLightGray() -> UIColor { return UIColor("#BBBBBB") }
    public class func luxeDarkGray() -> UIColor { return UIColor("#222222") }
    public class func luxeGray() -> UIColor { return UIColor("#666666") }
    public class func luxeCobaltBlue() -> UIColor { return UIColor("#1d50b1") }
    public class func luxeDuskBlue() -> UIColor { return UIColor("#243986") } // darker
    public class func luxeLinearGradient() -> UIColor { return UIColor("#F0FBFF") }
    public class func luxeCharcoalGrey() -> UIColor { return UIColor("#363b41") }
    public class func luxeLightestGray() -> UIColor { return UIColor("#ECECEC") }
    public class func luxeLightCobaltBlue() -> UIColor { return UIColor("#3f82d9") }
    public class func luxeLipstick() -> UIColor { return UIColor("#eb2853") }
    public class func luxeRed() -> UIColor { return UIColor("#DA3731") }
}
