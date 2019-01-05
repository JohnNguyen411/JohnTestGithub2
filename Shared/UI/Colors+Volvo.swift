//
//  Colors+Volvo.swift
//  voluxe-driver
//
//  Created by Christoph on 12/17/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class VolvoColors: ColorsImplementation {

    override init() {
        super.init()
        self.background = VolvoBackgroundColors()
        self.navigationBar = VolvoNavigationBarColors()
        self.table = VolvoTableColors()
    }

    // MARK: Monochrome

    override var black: UIColor      { return UIColor.black }
    override var white: UIColor      { return UIColor.white }

    // MARK: Primary

    override func red(_ shade: ColorsShade = .normal) -> UIColor {
        switch shade {
            case .dark:     return UIColor(rgb: 0xD84451)   // raspberry
            case .normal:   return UIColor(rgb: 0xE01D1D)   // signal error
            default:        assertionFailure("Color not implemented"); return .clear
        }
    }

    override func green(_ shade: ColorsShade = .normal) -> UIColor {
        switch shade {
            case .normal:   return UIColor(rgb: 0x64B80B)   // signal green
            case .light:    return UIColor(rgb: 0x78B833)   // grass
            case .lighter:  return UIColor(rgb: 0xC8E691)   // leaf
            default:        assertionFailure("Color not implemented"); return .clear
        }
    }

    override func blue(_ shade: ColorsShade = .normal) -> UIColor {
        switch shade {
            case .dark:     return UIColor(rgb: 0x182871)   // volvo blue
            case .normal:   return UIColor(rgb: 0x223AA3)   // volvo bright blue
            case .light:    return UIColor(rgb: 0x16A6C9)   // ocean
            case .lighter:  return UIColor(rgb: 0xBADCE6)   // sky
            case .lightest: return UIColor(rgb: 0xDCEDF2)   // sky 50
            default:        assertionFailure("Color not implemented"); return .clear
        }
    }

    // MARK: Secondary

    override func brown(_ shade: ColorsShade = .normal) -> UIColor {
        switch shade {
            case .normal:   return UIColor(rgb: 0x704E36)   // mud
            case .light:    return UIColor(rgb: 0xDCCCA7)   // sand
            default:        assertionFailure("Color not implemented"); return .clear
        }
    }

    override func grey(_ shade: ColorsShade = .normal) -> UIColor {
        switch shade {
            case .darker:   return UIColor(rgb: 0x333333)   // camera shutter view background
            case .dark:     return UIColor(rgb: 0x4D4F53)   // granite
            case .normal:   return UIColor(rgb: 0x9A9B9C)   // slate
            case .light:    return UIColor(rgb: 0xD5D6D2)   // fog
            case .lighter:  return UIColor(rgb: 0xE0E1DD)   // grey1
            case .lightest: return UIColor(rgb: 0xF0F0EE)   // grey0
            default:        assertionFailure("Color not implemented"); return .clear
        }
    }

    override func orange(_ shade: ColorsShade = .normal) -> UIColor {
        switch shade {
            case .normal:   return UIColor(rgb: 0xDD7611)   // cloud berry
            case .light:    return UIColor(rgb: 0xFCCC82)   // midnight sun
            default:        assertionFailure("Color not implemented"); return .clear
        }
    }

    override func purple(_ shade: ColorsShade = .normal) -> UIColor {
        switch shade {
            case .normal:   return UIColor(rgb: 0x763369)   // heather
            default:        assertionFailure("Color not implemented"); return .clear
        }
    }

    override func yellow(_ shade: ColorsShade = .normal) -> UIColor {
        switch shade {
            default:    return UIColor(rgb: 0xF8D11E)   // signal warning
        }
    }
}

class VolvoBackgroundColors: BackgroundColorsImplementation {
    override var light: UIColor { return UIColor.Volvo.white }
    override var dark: UIColor  { return UIColor.Volvo.grey0 }
}

class VolvoNavigationBarColors: NavigationBarColorsImplementation {
    override var background: UIColor    { return UIColor.Volvo.white }
    override var button: UIColor        { return UIColor.Volvo.granite }
    override var title: UIColor         { return UIColor.Volvo.black }
}

class VolvoTableColors: TableColorsImplementation {
    override var separator: UIColor { return UIColor.Volvo.grey1 }
}

// MARK:- Designer colors

extension VolvoColors {

    // reds
    var raspberry: UIColor      { return self.red(.dark) }
    var error: UIColor          { return self.red() }

    // blues
    var volvoBlue: UIColor      { return self.blue(.dark) }
    var brightBlue: UIColor     { return self.blue() }
    var ocean: UIColor          { return self.blue(.light) }
    var sky: UIColor            { return self.blue(.lighter) }
    var sky50: UIColor          { return self.blue(.lightest) }

    // greens
    var success: UIColor        { return self.green() }
    var grass: UIColor          { return self.green(.light) }
    var leaf: UIColor           { return self.green(.lighter) }

    // browns
    var mud: UIColor            { return self.brown() }
    var sand: UIColor           { return self.brown(.light) }

    // greys
    var granite: UIColor        { return self.grey(.dark) }
    var slate: UIColor          { return self.grey() }
    var fog: UIColor            { return self.grey(.light) }
    var grey1: UIColor          { return self.grey(.lighter) }
    var grey0: UIColor          { return self.grey(.lightest) }

    // oranges
    var cloudBerry: UIColor     { return self.orange() }
    var midnightSun: UIColor    { return self.orange(.light) }

    // purples
    var heather: UIColor        { return self.purple() }

    // yellows
    var warning: UIColor        { return self.yellow() }

    // other
    var shadow: UIColor         { return UIColor(rgb: 0x0, a: 0x61) }
}

// MARK:- Extension for global access

extension UIColor {

    static let Volvo = VolvoColors()
}
