//
//  Fonts.swift
//  hse
//
//  Created by Kimmo Lahdenkangas on 09/08/16.
//  Copyright © 2016 Volvo. All rights reserved.
//

import UIKit

class Fonts {

    static let fontWeightNovum: [String] = [UIFont.volvoNovumLight, UIFont.volvoNovumSemiLight, UIFont.volvoNovumRegular, UIFont.volvoNovumMedium, UIFont.volvoNovumBold]
    static let fontWeightNovumItalic: [String] = [UIFont.volvoNovumLightItalic, UIFont.volvoNovumSemiLightItalic, UIFont.volvoNovumRegularItalic, UIFont.volvoNovumMediumItalic, UIFont.volvoNovumBoldItalic]
    
    static let fontWeightVolvoSansPro: [String] = [UIFont.volvoSansProLight, UIFont.volvoSansProRegular, UIFont.volvoSansProMedium, UIFont.volvoSansProBold, UIFont.volvoSansProSuper]
    static let fontWeightVolvoSansProItalic: [String] = []

    enum FontType: String {
        case volvoSansPro = "Volvo Sans Pro"
        case volvoNovum = "Volvo Novum"
    }
    
    enum FontSize: CGFloat {
        case h1 = 96.0
        case h2 = 64.0
        case h3 = 48.0
        case h4 = 36.0
        case h5 = 24.0
        case h6 = 20.0
        case sub1 = 16.0
        case sub2 = 14.0
        case caption = 12.0
        case overline = 10.0
    }
    
    enum TrackingSize: CGFloat {
        case minus150 = -150.0
        case minus50 = -50.0
        case zero = 0.0
        case plus10 = 10.0
        case plus15 = 15.0
        case plus25 = 25.0
        case plus50 = 50.0
        case plus75 = 75.0
        case plus100 = 100.0
        case plus150 = 150.0
    }
    
    static var fontType = FontType.volvoSansPro //default font type
    
    static func fontWeight() -> [String] {
        if fontType == .volvoSansPro {
            return fontWeightVolvoSansPro
        } else {
            return fontWeightNovum
        }
    }
    
    static func italicFontWeight() -> [String] {
        if fontType == .volvoSansPro {
            return fontWeightVolvoSansProItalic
        } else {
            return fontWeightNovumItalic
        }
    }
    
    static func systemFontSize(text: String, size: CGFloat, color: UIColor? = nil) -> NSMutableAttributedString {
       return attributedString(text: text, font: UIFont.systemFont(ofSize: size))
    }
    
    static func H1(text: String, color: UIColor? = nil) -> NSMutableAttributedString {
        if fontType == .volvoSansPro {
            return attributedString(text: text, font: .volvoSansProLight(size: FontSize.h1.rawValue), spacing: TrackingSize.minus150.rawValue)
        } else {
            return attributedString(text: text, font: .volvoNovumLight(size: FontSize.h1.rawValue), spacing: TrackingSize.minus150.rawValue)
        }
    }
    
    static func H2(text: String, color: UIColor? = nil) -> NSMutableAttributedString {
        if fontType == .volvoSansPro {
            return attributedString(text: text, font: .volvoSansProLight(size: FontSize.h2.rawValue), spacing: TrackingSize.minus50.rawValue)
        } else {
            return attributedString(text: text, font: .volvoNovumLight(size: FontSize.h2.rawValue), spacing: TrackingSize.minus50.rawValue)
        }
    }
    
    static func H3(text: String, color: UIColor? = nil) -> NSMutableAttributedString {
        if fontType == .volvoSansPro {
            return attributedString(text: text, font: .volvoSansProLight(size: FontSize.h3.rawValue), spacing: TrackingSize.zero.rawValue)
        } else {
            return attributedString(text: text, font: .volvoNovumSemiLight(size: FontSize.h3.rawValue), spacing: TrackingSize.zero.rawValue)
        }
    }
    
    static func H4(text: String, color: UIColor? = nil) -> NSMutableAttributedString {
        if fontType == .volvoSansPro {
            return attributedString(text: text, font: .volvoSansProLight(size: FontSize.h4.rawValue), spacing: TrackingSize.plus25.rawValue)
        } else {
            return attributedString(text: text, font: .volvoNovumSemiLight(size: FontSize.h4.rawValue), spacing: TrackingSize.plus25.rawValue)
        }
    }
    
    static func H5(text: String, color: UIColor? = nil) -> NSMutableAttributedString {
        if fontType == .volvoSansPro {
            return attributedString(text: text, font: .volvoSansProRegular(size: FontSize.h5.rawValue), spacing: TrackingSize.zero.rawValue)
        } else {
            return attributedString(text: text, font: .volvoNovumRegular(size: FontSize.h5.rawValue), spacing: TrackingSize.zero.rawValue)
        }
    }
    
    static func H6(text: String, color: UIColor? = nil) -> NSMutableAttributedString {
        if fontType == .volvoSansPro {
            return attributedString(text: text, font: .volvoSansProMedium(size: FontSize.h6.rawValue), spacing: TrackingSize.plus15.rawValue)
        } else {
            return attributedString(text: text, font: .volvoNovumMedium(size: FontSize.h6.rawValue), spacing: TrackingSize.plus15.rawValue)
        }
    }
    
    static func Sub1(text: String, color: UIColor? = nil, spacing: CGFloat? = nil) -> NSMutableAttributedString {
        if fontType == .volvoSansPro {
            return attributedString(text: text, font: .volvoSansProRegular(size: FontSize.sub1.rawValue), spacing: spacing == nil ? TrackingSize.plus15.rawValue : spacing!)
        } else {
            return attributedString(text: text, font: .volvoNovumRegular(size: FontSize.sub1.rawValue), spacing: spacing == nil ? TrackingSize.plus15.rawValue : spacing!)
        }
    }
    
    static func Sub2(text: String, color: UIColor? = nil) -> NSMutableAttributedString {
        if fontType == .volvoSansPro {
            return attributedString(text: text, font: .volvoSansProMedium(size: FontSize.sub2.rawValue), spacing: TrackingSize.plus10.rawValue)
        } else {
            return attributedString(text: text, font: .volvoNovumMedium(size: FontSize.sub2.rawValue), spacing: TrackingSize.plus10.rawValue)
        }
    }
    
    static func Body1(text: String, color: UIColor? = nil) -> NSMutableAttributedString {
        if fontType == .volvoSansPro {
            return attributedString(text: text, font: .volvoSansProRegular(size: FontSize.sub1.rawValue), spacing: TrackingSize.zero.rawValue)
        } else {
            return attributedString(text: text, font: .volvoNovumRegular(size: FontSize.sub1.rawValue), spacing: TrackingSize.zero.rawValue)
        }
    }
    
    static func Body2(text: String, color: UIColor? = nil) -> NSMutableAttributedString {
        if fontType == .volvoSansPro {
            return attributedString(text: text, font: .volvoSansProRegular(size: FontSize.sub2.rawValue), spacing: TrackingSize.plus25.rawValue)
        } else {
            return attributedString(text: text, font: .volvoNovumRegular(size: FontSize.sub2.rawValue), spacing: TrackingSize.plus25.rawValue)
        }
    }
    
    static func button(text: String, color: UIColor? = nil) -> NSMutableAttributedString {
        if fontType == .volvoSansPro {
            return attributedString(text: text, font: .volvoSansProMedium(size: FontSize.sub2.rawValue), spacing: TrackingSize.plus75.rawValue)
        } else {
            return attributedString(text: text, font: .volvoNovumMedium(size: FontSize.sub2.rawValue), spacing: TrackingSize.plus75.rawValue)
        }
    }
    
    static func caption(text: String, color: UIColor? = nil) -> NSMutableAttributedString {
        if fontType == .volvoSansPro {
            return attributedString(text: text, font: .volvoSansProRegular(size: FontSize.caption.rawValue), spacing: TrackingSize.plus50.rawValue)
        } else {
            return attributedString(text: text, font: .volvoNovumRegular(size: FontSize.caption.rawValue), spacing: TrackingSize.plus50.rawValue)
        }
    }
    
    static func captionMedium(text: String, color: UIColor? = nil) -> NSMutableAttributedString {
        if fontType == .volvoSansPro {
            return attributedString(text: text, font: .volvoSansProMedium(size: FontSize.caption.rawValue), spacing: TrackingSize.plus100.rawValue)
        } else {
            return attributedString(text: text, font: .volvoNovumMedium(size: FontSize.caption.rawValue), spacing: TrackingSize.plus100.rawValue)
        }
    }
    
    static func overline(text: String, color: UIColor? = nil) -> NSMutableAttributedString {
        if fontType == .volvoSansPro {
            return attributedString(text: text, font: .volvoSansProMedium(size: FontSize.overline.rawValue), spacing: TrackingSize.plus150.rawValue)
        } else {
            return attributedString(text: text, font: .volvoNovumMedium(size: FontSize.overline.rawValue), spacing: TrackingSize.plus150.rawValue)
        }
    }
    
    
    static func fontForAttributedString(attStr: NSMutableAttributedString) -> UIFont {
        var range = NSRange()
        if let font = attStr.attribute(NSAttributedStringKey.font, at: 0, effectiveRange: &range) as? UIFont {
            return font
        } else {
            return UIFont.systemFont(ofSize: 16)
        }
    }
    
    static func updateLetterSpacing(attStr: NSMutableAttributedString, spacing: CGFloat) -> NSMutableAttributedString{
        let range = NSRange(location: 0, length: attStr.length)
        let font = fontForAttributedString(attStr: attStr)
        attStr.addAttribute(NSAttributedStringKey.kern, value: letterSpacing(font: font, spacing: spacing), range: range)
        return attStr
    }
 

    static func attributedString(text: String, font: UIFont, color: UIColor? = nil, spacing: CGFloat? = nil) -> NSMutableAttributedString {
        let range = NSRange(location: 0, length: text.count)
        let attStr = NSMutableAttributedString(string: text)
        if let spacing = spacing {
            attStr.addAttribute(NSAttributedStringKey.kern, value: letterSpacing(font: font, spacing: spacing), range: range)
        }
        attStr.addAttribute(NSAttributedStringKey.font, value: font, range: range)
        if let color = color {
            attStr.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
        }
        return attStr
    }

    static func letterSpacing(font: UIFont, spacing: CGFloat) -> CGFloat {
        return font.pointSize * spacing / 1000
    }
}
