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

// MARK:- Font Family (Volvo, Novum)

enum FontFamily {
    case volvo
    case novum
}

// MARK:- Font names for weights

struct FontName {
    
    static var family: FontFamily = .novum
    
    static var light: String {
        if family == .volvo {
            return "VolvoSansPro-Light"
        } else {
            return "VolvoNovum-Light"
        }
    }
    
    static var semiLight: String {
        if family == .volvo {
            return "VolvoSansPro-Light"
        } else {
            return "VolvoNovum-SemiLight"
        }
    }
    
    static var regular: String {
        if family == .volvo {
            return "VolvoSansPro-Regular"
        } else {
            return "VolvoNovum-Regular"
        }
    }
    
    static var italic: String {
        return "VolvoNovum-Italic"
    }
    
    static var medium: String {
        if family == .volvo {
            return "VolvoSansPro-Medium"
        } else {
            return "VolvoNovum-Medium"
        }
    }
    
    static var bold: String {
        if family == .volvo {
            return "VolvoSansPro-Bold"
        } else {
            return "VolvoNovum-Bold"
        }
    }
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
    
    static func italic(size: Int) -> UIFont {
        return UIFont.customFont(fontName: FontName.italic, size: CGFloat(size)).scaled()
    }

    static func medium(size: Int) -> UIFont {
        return UIFont.customFont(fontName: FontName.medium, size: CGFloat(size)).scaled()
    }

    static func bold(size: Int) -> UIFont {
        return UIFont.customFont(fontName: FontName.bold, size: CGFloat(size)).scaled()
    }
}

// MARK:- Font size

fileprivate struct FontSize {
    static let extraSmall = Int(9)  // 9, 10, 11
    static let small = Int(12)      // 12, 13
    static let intermediate = Int(14)      // 14
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
        static let italic = FontWeight.italic(size: FontSize.extraSmall)
        static let medium = FontWeight.medium(size: FontSize.extraSmall)
        static let bold = FontWeight.bold(size: FontSize.extraSmall)
    }

    struct Small {
        static let light = FontWeight.light(size: FontSize.small)
        static let semiLight = FontWeight.semiLight(size: FontSize.small)
        static let regular = FontWeight.regular(size: FontSize.small)
        static let italic = FontWeight.italic(size: FontSize.small)
        static let medium = FontWeight.medium(size: FontSize.small)
        static let bold = FontWeight.bold(size: FontSize.small)
    }
    
    struct Intermediate {
        static let light = FontWeight.light(size: FontSize.intermediate)
        static let semiLight = FontWeight.semiLight(size: FontSize.intermediate)
        static let regular = FontWeight.regular(size: FontSize.intermediate)
        static let italic = FontWeight.italic(size: FontSize.intermediate)
        static let medium = FontWeight.medium(size: FontSize.intermediate)
        static let bold = FontWeight.bold(size: FontSize.intermediate)
    }

    struct Medium {
        static let light = FontWeight.light(size: FontSize.medium)
        static let semiLight = FontWeight.semiLight(size: FontSize.medium)
        static let regular = FontWeight.regular(size: FontSize.medium)
        static let italic = FontWeight.italic(size: FontSize.medium)
        static let medium = FontWeight.medium(size: FontSize.medium)
        static let bold = FontWeight.bold(size: FontSize.medium)
    }

    struct Large {
        static let light = FontWeight.light(size: FontSize.large)
        static let semiLight = FontWeight.semiLight(size: FontSize.large)
        static let regular = FontWeight.regular(size: FontSize.large)
        static let italic = FontWeight.italic(size: FontSize.large)
        static let medium = FontWeight.medium(size: FontSize.large)
        static let bold = FontWeight.bold(size: FontSize.large)
    }

    struct ExtraLarge {
        static let light = FontWeight.light(size: FontSize.extraLarge)
        static let semiLight = FontWeight.semiLight(size: FontSize.extraLarge)
        static let regular = FontWeight.regular(size: FontSize.extraLarge)
        static let italic = FontWeight.italic(size: FontSize.extraLarge)
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

// This should follow the code pattern established by Colors.swift
// to be flexible and reusable for multiple clients.
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
