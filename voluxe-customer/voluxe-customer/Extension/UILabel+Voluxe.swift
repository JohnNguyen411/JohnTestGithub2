//
//  UILabel+Voluxe.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 3/22/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

extension UILabel {
    func setHTMLFromString(text: String) {
        let modifiedFont = NSString(format:"<span style=\"font-family: \(self.font!.fontName); font-size: \(self.font!.pointSize)\">%@</span>" as NSString, text)
        
        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: String.Encoding.unicode.rawValue, allowLossyConversion: true)!,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        
        self.attributedText = attrStr
    }
    
    func addCharacterSpacing(kernValue: Float) {
        if let labelText = text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedStringKey.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
    
    func addUppercasedCharacterSpacing() {
        self.addCharacterSpacing(kernValue: UILabel.uppercasedKern())
    }
    
    
    func lineSpacing(lineSpacing: CGFloat) {
        if let labelText = text, labelText.count > 0 {
            
            let paragraphStyle = NSMutableParagraphStyle()
            //line height size
            paragraphStyle.lineSpacing = lineSpacing
            
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
            attributedText = attributedString
        }
    }
    
    
    func volvoProLineSpacing() {
        self.lineSpacing(lineSpacing: 4.0)
    }
    
    static func uppercasedKern() -> Float {
        return 0.4
    }
    
    static func defaultKern() -> Float {
        return 0.0
    }
    
}
