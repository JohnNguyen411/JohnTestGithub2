//
//  Fonts.swift
//  hse
//
//  Created by Kimmo Lahdenkangas on 09/08/16.
//  Copyright © 2016 Volvo. All rights reserved.
//

import UIKit

class Fonts {

    static let lightFontName = "VolvoSansPro-Light"
    static let regularFontName = "VolvoSansPro-Regular"
    static let mediumFontName = "VolvoSansPro-Medium"
    static let italicFontName = "VolvoSerifPro-Italic"

    static let FONT_H1 = UIFont(name: lightFontName, size: 30)
    static let FONT_H2 = UIFont(name: lightFontName, size: 23)
    static let FONT_H3 = UIFont(name: mediumFontName, size: 11)

    static let FONT_CTA = UIFont(name: mediumFontName, size: 13)

    static let FONT_B1 = UIFont(name: lightFontName, size: 18)
    static let FONT_B1_REGULAR = UIFont(name: regularFontName, size: 18)
    static let FONT_B2 = UIFont(name: lightFontName, size: 16)
    static let FONT_B2_REGULAR = UIFont(name: regularFontName, size: 16)
    static let FONT_B3 = UIFont(name: lightFontName, size: 14)
    static let FONT_B4 = UIFont(name: lightFontName, size: 12)
    static let FONT_B5 = UIFont(name: lightFontName, size: 10)
    static let FONT_B5_REGULAR = UIFont(name: regularFontName, size: 10)

    static let FONT_LABEL = UIFont(name: mediumFontName, size: 12)

    static let LETTER_SPACING_SMALL = CGFloat(10)
    static let LETTER_SPACING_LARGE = CGFloat(100)

    static func H1(text: String) -> NSMutableAttributedString {
        return attributedString(text: text, font: Fonts.FONT_H1!, color: ColorDefinitions.blackTextColor, spacing: LETTER_SPACING_SMALL)
    }

    static func H2(text: String) -> NSMutableAttributedString {
        return attributedString(text: text, font: Fonts.FONT_H2!, color: ColorDefinitions.blackTextColor, spacing: LETTER_SPACING_SMALL)
    }

    static func H2_White(text: String) -> NSMutableAttributedString {
        return attributedString(text: text, font: Fonts.FONT_H2!, color: ColorDefinitions.fadeToWhiteColor, spacing: LETTER_SPACING_SMALL)
    }

    static func H3(text: String) -> NSMutableAttributedString {
        return attributedString(text: text.uppercased(), font: Fonts.FONT_H3!, color: ColorDefinitions.blackTextColor, spacing: LETTER_SPACING_SMALL)
    }

    static func H3_White(text: String) -> NSMutableAttributedString {
        return attributedString(text: text, font: Fonts.FONT_H3!, color: ColorDefinitions.fadeToWhiteColor, spacing: LETTER_SPACING_SMALL)
    }

    static func LABEL(text: String) -> NSMutableAttributedString {
        return attributedString(text: text.uppercased(), font: Fonts.FONT_LABEL!, color: ColorDefinitions.blackTextColor, spacing: LETTER_SPACING_SMALL)
    }

    static func LABEL_WHITE(text: String) -> NSMutableAttributedString {
        return attributedString(text: text.uppercased(), font: Fonts.FONT_LABEL!, color: ColorDefinitions.fadeToWhiteColor, spacing: LETTER_SPACING_SMALL)
    }

    static func CTA(text: String) -> NSMutableAttributedString {
        return attributedString(text: text.uppercased(), font: Fonts.FONT_CTA!, color: ColorDefinitions.blueTextColor, spacing: LETTER_SPACING_LARGE)
    }

    static func CTA_White(text: String) -> NSMutableAttributedString {
        return attributedString(text: text.uppercased(), font: Fonts.FONT_CTA!, color: ColorDefinitions.fadeToWhiteColor, spacing: LETTER_SPACING_LARGE)
    }

    static func CTA_Gray(text: String) -> NSMutableAttributedString {
        return attributedString(text: text.uppercased(), font: Fonts.FONT_CTA!, color: ColorDefinitions.grayTextColor, spacing: LETTER_SPACING_LARGE)
    }

    static func CTA_Black(text: String) -> NSMutableAttributedString {
        return attributedString(text: text.uppercased(), font: Fonts.FONT_CTA!, color: ColorDefinitions.blackTextColor, spacing: LETTER_SPACING_LARGE)
    }

    static func B1(text: String) -> NSMutableAttributedString {
        return attributedString(text: text, font: Fonts.FONT_B1!, color: ColorDefinitions.blackTextColor, spacing: LETTER_SPACING_SMALL)
    }

    static func B1_Blue(text: String) -> NSMutableAttributedString {
        return attributedString(text: text, font: Fonts.FONT_B1!, color: ColorDefinitions.blueTextColor, spacing: LETTER_SPACING_SMALL)
    }

	static func B1_White(text: String) -> NSMutableAttributedString {
		return attributedString(text: text, font: Fonts.FONT_B1!, color: ColorDefinitions.fadeToWhiteColor, spacing: LETTER_SPACING_SMALL)
	}

    static func B1_Blue_Regular(text: String) -> NSMutableAttributedString {
        return attributedString(text: text, font: Fonts.FONT_B1_REGULAR!, color: ColorDefinitions.blueTextColor, spacing: LETTER_SPACING_SMALL)
    }

	static func B1_LightGray_Regular(text: String) -> NSMutableAttributedString {
		return attributedString(text: text, font: Fonts.FONT_B1_REGULAR!, color: ColorDefinitions.lightGray, spacing: LETTER_SPACING_SMALL)
	}

    static func B1_MediumGray(text: String) -> NSMutableAttributedString {
        return attributedString(text: text, font: Fonts.FONT_B1!, color: ColorDefinitions.mediumGray, spacing: LETTER_SPACING_SMALL)
    }

    static func B1_CodGray(text: String) -> NSMutableAttributedString {
        return attributedString(text: text, font: Fonts.FONT_B1!, color: ColorDefinitions.codGray, spacing: LETTER_SPACING_SMALL)
    }

    static func B1_Regular(text: String) -> NSMutableAttributedString {
        return attributedString(text: text, font: Fonts.FONT_B1_REGULAR!, color: ColorDefinitions.blackTextColor, spacing: LETTER_SPACING_SMALL)
    }

    static func B2(text: String) -> NSMutableAttributedString {
        return attributedString(text: text, font: Fonts.FONT_B2!, color: ColorDefinitions.blackTextColor, spacing: LETTER_SPACING_SMALL)
    }

    static func B2_Bold(text: String) -> NSMutableAttributedString {
        return attributedString(text: text, font: Fonts.FONT_B2_REGULAR!, color: ColorDefinitions.blackTextColor, spacing: LETTER_SPACING_SMALL)
    }

    static func B2_MediumGray(text: String) -> NSMutableAttributedString {
        return attributedString(text: text, font: Fonts.FONT_B2!, color: ColorDefinitions.mediumGray, spacing: LETTER_SPACING_SMALL)
    }

    static func B2_Blue(text: String) -> NSMutableAttributedString {
        return attributedString(text: text, font: Fonts.FONT_B2!, color: ColorDefinitions.blue, spacing: LETTER_SPACING_SMALL)
    }

    static func B2_MediumRed(text: String) -> NSMutableAttributedString {
        return attributedString(text: text, font: Fonts.FONT_B2!, color: ColorDefinitions.red, spacing: LETTER_SPACING_SMALL)
    }

    static func B2_CodGray(text: String) -> NSMutableAttributedString {
        return attributedString(text: text, font: Fonts.FONT_B2!, color: ColorDefinitions.codGray, spacing: LETTER_SPACING_SMALL)
    }

    static func B3(text: String) -> NSMutableAttributedString {
        return attributedString(text: text, font: Fonts.FONT_B3!, color: ColorDefinitions.blackTextColor, spacing: LETTER_SPACING_SMALL)
    }

    static func B3_MediumGray(text: String) -> NSMutableAttributedString {
        return attributedString(text: text, font: Fonts.FONT_B3!, color: ColorDefinitions.mediumGray, spacing: LETTER_SPACING_SMALL)
    }

    static func B3_CodGray(text: String) -> NSMutableAttributedString {
        return attributedString(text: text, font: Fonts.FONT_B3!, color: ColorDefinitions.codGray, spacing: LETTER_SPACING_SMALL)
    }

    static func B3_LightGray(text: String) -> NSMutableAttributedString {
        return attributedString(text: text, font: Fonts.FONT_B3!, color: ColorDefinitions.lightGray, spacing: LETTER_SPACING_SMALL)
    }

    static func B3_Blue(text: String) -> NSMutableAttributedString {
        return attributedString(text: text, font: Fonts.FONT_B3!, color: ColorDefinitions.blueTextColor, spacing: LETTER_SPACING_SMALL)
    }

	static func B3_White(text: String) -> NSMutableAttributedString {
		return attributedString(text: text, font: Fonts.FONT_B3!, color: ColorDefinitions.fadeToWhiteColor, spacing: LETTER_SPACING_SMALL)
	}

    static func B4(text: String) -> NSMutableAttributedString {
        return attributedString(text: text, font: Fonts.FONT_B4!, color: ColorDefinitions.grayTextColor, spacing: LETTER_SPACING_SMALL)
    }

    static func B4_Black(text: String) -> NSMutableAttributedString {
        return attributedString(text: text, font: Fonts.FONT_B4!, color: ColorDefinitions.blackTextColor, spacing: LETTER_SPACING_SMALL)
    }

    static func B4_Blue(text: String) -> NSMutableAttributedString {
        return attributedString(text: text, font: Fonts.FONT_B4!, color: ColorDefinitions.blueTextColor, spacing: LETTER_SPACING_SMALL)
    }

    static func B4_CodGray(text: String) -> NSMutableAttributedString {
        return attributedString(text: text, font: Fonts.FONT_B4!, color: ColorDefinitions.codGray, spacing: LETTER_SPACING_SMALL)
    }

    static func B5(text: String) -> NSMutableAttributedString {
        return attributedString(text: text, font: Fonts.FONT_B5!, color: ColorDefinitions.grayTextColor, spacing: LETTER_SPACING_SMALL)
    }

    static func B5_Black(text: String) -> NSMutableAttributedString {
        return attributedString(text: text, font: Fonts.FONT_B5_REGULAR!, color: ColorDefinitions.blackTextColor, spacing: LETTER_SPACING_SMALL)
    }

    static func B4_MediumGray(text: String) -> NSMutableAttributedString {
        return attributedString(text: text, font: Fonts.FONT_B4!, color: ColorDefinitions.mediumGray, spacing: LETTER_SPACING_SMALL)
    }

    static func attributedString(text: String, font: UIFont, color: UIColor, spacing: CGFloat) -> NSMutableAttributedString {
        let range = NSRange(location: 0, length: text.count)
        let attStr = NSMutableAttributedString(string: text)
        attStr.addAttribute(NSAttributedStringKey.kern, value: letterSpacing(font: font, spacing: spacing), range: range)
        attStr.addAttribute(NSAttributedStringKey.font, value: font, range: range)
        attStr.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
        return attStr
    }

    static func letterSpacing(font: UIFont, spacing: CGFloat) -> CGFloat {
        return font.pointSize * spacing / 1000
    }
}
