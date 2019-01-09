//
//  Font.swift
//  voluxe-customer
//
//  Created by Christoph on 9/14/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

// MARK:- UIFont for UIFontMetrics

extension UIFont {

    public class func customFont(fontName: String, size: CGFloat) -> UIFont {
        return UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize:size)
    }

    public func scaled() -> UIFont {
        if #available(iOS 11.0, *) {
            return UIFontMetrics.default.scaledFont(for: self)
        } else {
            return self
        }
    }
}

// MARK:- Font names for weights

fileprivate struct FontName {
    static let light = "VolvoNovum-Light"
    static let semiLight = "VolvoNovum-SemiLight"
    static let regular = "VolvoNovum-Regular"
    static let medium = "VolvoNovum-Medium"
    static let bold = "VolvoNovum-Bold"
}

// MARK:- Font weight

// FontBase can be used for multiple font families.
// Fileprivate to prevent random font creation.
// Ints to prevent fractional sizes (sometimes design files accidentally have them)
fileprivate struct FontWeight {

    static func light(size: Int) -> UIFont {
        return UIFont.customFont(fontName: FontName.light, size: CGFloat(size)).scaled()
    }

    static func semiLight(size: Int) -> UIFont {
        return UIFont.customFont(fontName: FontName.semiLight, size: CGFloat(size)).scaled()
    }

    static func regular(size: Int) -> UIFont {
        return UIFont.customFont(fontName: FontName.regular, size: CGFloat(size)).scaled()
    }

    static func medium(size: Int) -> UIFont {
        return UIFont.customFont(fontName: FontName.medium, size: CGFloat(size)).scaled()
    }

    static func bold(size: Int) -> UIFont {
        return UIFont.customFont(fontName: FontName.bold, size: CGFloat(size)).scaled()
    }
}

// MARK:- Font size

// TODO can this extend Int?
fileprivate struct FontSize {
    static let extraSmall = Int(9)  // 9, 10, 11
    static let small = Int(12)      // 12, 13, 14, 15
    static let medium = Int(16)     // 16, 18
    static let large = Int(20)
    static let extraLarge = Int(38)
}

// MARK:- Fonts by size and weight

struct Font {

    struct ExtraSmall {
        static let light = FontWeight.light(size: FontSize.extraSmall)
        static let semiLight = FontWeight.semiLight(size: FontSize.extraSmall)
        static let regular = FontWeight.regular(size: FontSize.extraSmall)
        static let medium = FontWeight.medium(size: FontSize.extraSmall)
        static let bold = FontWeight.bold(size: FontSize.extraSmall)
    }

    struct Small {
        static let light = FontWeight.light(size: FontSize.small)
        static let semiLight = FontWeight.semiLight(size: FontSize.small)
        static let regular = FontWeight.regular(size: FontSize.small)
        static let medium = FontWeight.medium(size: FontSize.small)
        static let bold = FontWeight.bold(size: FontSize.small)
    }

    struct Medium {
        static let light = FontWeight.light(size: FontSize.medium)
        static let semiLight = FontWeight.semiLight(size: FontSize.medium)
        static let regular = FontWeight.regular(size: FontSize.medium)
        static let medium = FontWeight.medium(size: FontSize.medium)
        static let bold = FontWeight.bold(size: FontSize.medium)
    }

    struct Large {
        static let light = FontWeight.light(size: FontSize.large)
        static let semiLight = FontWeight.semiLight(size: FontSize.large)
        static let regular = FontWeight.regular(size: FontSize.large)
        static let medium = FontWeight.medium(size: FontSize.large)
        static let bold = FontWeight.bold(size: FontSize.large)
    }

    struct ExtraLarge {
        static let light = FontWeight.light(size: FontSize.extraLarge)
        static let semiLight = FontWeight.semiLight(size: FontSize.extraLarge)
        static let regular = FontWeight.regular(size: FontSize.extraLarge)
        static let medium = FontWeight.medium(size: FontSize.extraLarge)
        static let bold = FontWeight.bold(size: FontSize.extraLarge)
    }
}

// MARK:- Fonts by UIFontMetrics

extension UIFont.TextStyle {

    var font: UIFont {

        // newer styles
        if #available(iOS 11.0, *) {
            if self == .largeTitle { return Font.ExtraLarge.bold }
        }

        // UIFontMetrics from iOS 10
        switch self {
            case .title1:       return Font.Large.bold
            case .title2:       return Font.Medium.bold
            case .title3:       return Font.Medium.regular
            case .headline:     return Font.Medium.bold
            case .subheadline:  return Font.Small.light
            case .body:         return Font.Medium.regular
            case .callout:      return Font.Small.light
            case .caption1:     return Font.Medium.regular
            case .caption2:     return Font.Medium.semiLight
            default:            return Font.Medium.regular
        }
    }
}

// MARK:- Fonts by design

// TODO this should be defined as a protocl
// with specific implementations like Volvo, Polestar, etc
extension Font {

    struct Volvo {
        static let h1 = FontWeight.light(size: 96)
        static let h2 = FontWeight.light(size: 64)
        static let h3 = FontWeight.semiLight(size: 48)
        static let h4 = FontWeight.semiLight(size: 36)
        static let h5 = FontWeight.regular(size: 24)
        static let h6 = UIFont.systemFont(ofSize: 20, weight: .regular) // nav bar title
        static let subtitle1 = UIFont.systemFont(ofSize: 16, weight: .regular) // request cell primary
        static let subtitle2 = UIFont.systemFont(ofSize: 14, weight: .regular) // request cell secondary
        static let body1 = UIFont.systemFont(ofSize: 16, weight: .regular) // permission body copy
        static let body2 = FontWeight.regular(size: 14)
        static let button = UIFont.systemFont(ofSize: 14, weight: .medium)  // landing page buttons
        static let caption = UIFont.systemFont(ofSize: 12, weight: .medium) // section header, swipe next label
        static let overline = FontWeight.medium(size: 10)
    }

    enum Polestar {
        case h6
        case caption
    }

//    extension Polestar {
//        func to() -> UIFont {
//            switch self {
//                case .h6: return Font.Volvo.h6
//                case .caption: return Font.Volvo.caption
//            }
//        }
//    }
}

// MARK:- Font by use

extension UIFont {

    enum FontByUse {
        case headerTitle
        case bodyTitle
        case bodyText
        case primaryButton
        case secondaryButton
    }
}

// enum for fonts by use + func to generate font based on switch
// attributed string extension with func to generate kerned string by enum
// custom extension for volvo
// custom extension for polestar

extension UIFont.FontByUse {

    func kerned() -> UIFont {
        switch self {
            default: return Font.Volvo.h6
        }
    }
}

// MARK:- Exceptions

extension Font {}
