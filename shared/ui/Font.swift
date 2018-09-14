//
//  Font.swift
//  voluxe-customer
//
//  Created by Christoph on 9/14/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

// MARK:- UIFont for UIFontMetrics

extension UIFont {

    public func scaled() -> UIFont {
        if #available(iOS 11.0, *) {
            return UIFontMetrics.default.scaledFont(for: self)
        } else {
            return self
        }
    }
}

// MARK:- Font basics

// FontBase can be used for multiple font families.
// Fileprivate to prevent random font creation.
// Ints to prevent fractional sizes (sometimes design files accidentally have them)
struct FontWeight {

    fileprivate static func light(size: Int) -> UIFont {
        return UIFont.customFont(fontName: "VolvoNovum-Light", size: CGFloat(size)).scaled()
    }

    fileprivate static func regular(size: Int) -> UIFont {
        return UIFont.customFont(fontName: "VolvoNovum-SemiLight", size: CGFloat(size)).scaled()
    }

    fileprivate static func medium(size: Int) -> UIFont {
        return UIFont.customFont(fontName: "VolvoNovum-Regular", size: CGFloat(size)).scaled()
    }

    fileprivate static func bold(size: Int) -> UIFont {
        return UIFont.customFont(fontName: "VolvoNovum-Medium", size: CGFloat(size)).scaled()
    }

    fileprivate static func heavy(size: Int) -> UIFont {
        return UIFont.customFont(fontName: "VolvoNovum-Bold", size: CGFloat(size)).scaled()
    }
}

// MARK:- Font size

// TODO does this need to be private?
// TODO can UIFont() be made private?
// TODO can this extend Int?
struct FontSize {
    static let extraSmall = Int(9)  // 9, 10, 11
    static let small = Int(12)      // 12, 13, 14, 15
    static let medium = Int(16)     // 16, 18
    static let large = Int(20)
    static let extraLarge = Int(38)
}

// MARK:- Fonts by size and weight

// TODO once a constant is used it is stored and will not react to DynamicType changes
// TODO figure out how to detect type changes OR change the constants into funcs
struct Font {

    struct ExtraSmall {
        static let light = FontWeight.light(size: FontSize.extraSmall)
        static let regular = FontWeight.regular(size: FontSize.extraSmall)
        static let medium = FontWeight.medium(size: FontSize.extraSmall)
        static let bold = FontWeight.bold(size: FontSize.extraSmall)
        static let heavy = FontWeight.heavy(size: FontSize.extraSmall)
    }

    struct Small {
        static let light = FontWeight.light(size: FontSize.small)
        static let regular = FontWeight.regular(size: FontSize.small)
        static let medium = FontWeight.medium(size: FontSize.small)
        static let bold = FontWeight.bold(size: FontSize.small)
        static let heavy = FontWeight.heavy(size: FontSize.small)
    }

    struct Medium {
        static let light = FontWeight.light(size: FontSize.medium)
        static let regular = FontWeight.regular(size: FontSize.medium)
        static let medium = FontWeight.medium(size: FontSize.medium)
        static let bold = FontWeight.bold(size: FontSize.medium)
        static let heavy = FontWeight.heavy(size: FontSize.medium)
    }

    struct Large {
        static let light = FontWeight.light(size: FontSize.large)
        static let regular = FontWeight.regular(size: FontSize.large)
        static let medium = FontWeight.medium(size: FontSize.large)
        static let bold = FontWeight.bold(size: FontSize.large)
        static let heavy = FontWeight.heavy(size: FontSize.large)
    }

    struct ExtraLarge {
        static let light = FontWeight.light(size: FontSize.extraLarge)
        static let regular = FontWeight.regular(size: FontSize.extraLarge)
        static let medium = FontWeight.medium(size: FontSize.extraLarge)
        static let bold = FontWeight.bold(size: FontSize.extraLarge)
        static let heavy = FontWeight.heavy(size: FontSize.extraLarge)
    }
}

// MARK:- Fonts by UIFontMetrics

extension Font {

    // conforms to UIFont.TextStyle
    struct TextStyle {
        static let largeTitle = Font.ExtraLarge.bold
        static let title1 = Font.Large.bold
        static let title2 = Font.Medium.bold
        static let title3 = Font.Medium.regular
        static let headline = Font.Medium.bold
        static let subheadline = Font.Small.light
        static let body = Font.Medium.regular
        static let callout = Font.Small.light
        static let caption1 = Font.Medium.regular
        static let caption2 = Font.Medium.light
    }

    // TODO how to support .largeTitle?
    static func with(style: UIFont.TextStyle) -> UIFont {
        switch style {
            //            if #available(iOS 11.0, *) {
            //                case .largeTitle: return FontMetrics.largeTitle
        //            }
        case .title1: return TextStyle.title1
        case .title2: return TextStyle.title2
        case .title3: return TextStyle.title3
        case .headline: return TextStyle.headline
        case .subheadline: return TextStyle.subheadline
        case .body: return TextStyle.body
        case .callout: return TextStyle.callout
        case .caption1: return TextStyle.caption1
        case .caption2: return TextStyle.caption2
        default: return TextStyle.body
        }
    }
}

// MARK:- Fonts by design

extension Font {

    // title
    // body
    // button
    // map
}

// MARK:- Exceptions

extension Font {

    // random element
}
