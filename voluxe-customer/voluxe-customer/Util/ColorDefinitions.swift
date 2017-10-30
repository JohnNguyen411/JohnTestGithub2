//
//  ColorDefinitions.swift
//  hse
//
//  Created by Henrik Roslund on 31/05/16.
//  Copyright © 2016 Volvo. All rights reserved.
//

import Foundation
import UIKit
import UIColor_Hex_Swift

class ColorDefinitions {

    static let buttonEnabledColor = UIColor.init(red: 0.5921568627451, green: 0.71372549019608, blue: 0.8, alpha: 0.7)
    static let buttonPressedColor = UIColor.init(red: 0.5921568627451, green: 0.71372549019608, blue: 0.8, alpha: 1.0)
    static let buttonDisabledColor = UIColor.init(red: 0.92, green: 0.92, blue: 0.92, alpha: 1.0)

    static let buttonRedEnabledColor = UIColor.init(red: 0.95, green: 0.55, blue: 0.5, alpha: 1)
    static let buttonRedPressedColor = UIColor.init(red: 0.95, green: 0.55, blue: 0.5, alpha: 0.7)

    static let itemSelectedColor = UIColor.init(red: 0.5921568627451, green: 0.71372549019608, blue: 0.8, alpha: 0.7)
    static let itemNormalColor = UIColor.white

    static let buttonEnabledTextColor = UIColor.black
    static let buttonDisabledTextColor = UIColor.lightGray

    static let fadeToWhiteColor = UIColor.white
    static let fadeToWhiteTransparentColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0)

    static let shadowColor = lightGray
    static let blackTopBorder = codGray
    static let silverTopBorder = lightGray

    static let blueButtonColorNormal = UIColor("#007BCD")
    static let blueButtonColorPressed = UIColor("#007BCD80")
    static let blueButtonColorDisabled = UIColor("#DDDDDD")
	static let blueButtonColorDark = UIColor("#327AC7")

    static let blackButtonColorNormal = codGray
    static let blackButtonColorPressed = codGray50
    static let blackButtonColorDisabled = lightGray

    static let blackTextColor = codGray
    static let blueTextColor = blue
    static let grayTextColor = mediumGray

    static let codGray = UIColor("#161618")
    static let codGray50 = UIColor("#8A8A8A")
    static let mediumGray = UIColor("#999999")
    static let lightGray = UIColor("#DDDDDD")
    static let wildSand = UIColor("#F6F6F6")
    static let blue = UIColor("#007BCD")
    static let red = UIColor("#E52020")

    static let separatorColor = lightGray
}
