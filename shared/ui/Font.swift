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

    static func with(style: UIFont.TextStyle) -> UIFont {

        // newer styles
        if #available(iOS 11.0, *) {
            if style == .largeTitle { return TextStyle.largeTitle }
        }

        // UIFontMetrics from iOS 10
        if style == .title1             { return TextStyle.title1 }
        else if style == .title2        { return TextStyle.title2 }
        else if style == .title3        { return TextStyle.title3 }
        else if style == .headline      { return TextStyle.headline }
        else if style == .subheadline   { return TextStyle.subheadline }
        else if style == .body          { return TextStyle.body }
        else if style == .callout       { return TextStyle.callout }
        else if style == .caption1      { return TextStyle.caption1 }
        else if style == .caption2      { return TextStyle.caption2 }

        // default for unknown types
        else { return TextStyle.body }
    }
}

// MARK:- Fonts by design

extension Font {

    struct Volvo {
        static let h1 = FontWeight.light(size: 96)
        static let h2 = FontWeight.light(size: 64)
        static let h3 = FontWeight.semiLight(size: 48)
        static let h4 = FontWeight.semiLight(size: 36)
        static let h5 = FontWeight.regular(size: 24)
        static let h6 = FontWeight.medium(size: 20)
        static let subtitle1 = FontWeight.regular(size: 16)
        static let subtitle2 = FontWeight.medium(size: 14)
        static let body1 = FontWeight.regular(size: 16)
        static let body2 = FontWeight.regular(size: 14)
        static let button = FontWeight.medium(size: 14) // should be in functional fonts
        static let caption = FontWeight.regular(size: 12)
        static let overline = FontWeight.medium(size: 10)
    }
}

// MARK:- Exceptions

extension Font {}
