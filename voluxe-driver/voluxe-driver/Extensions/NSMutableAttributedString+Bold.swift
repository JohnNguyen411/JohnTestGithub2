//
//  NSMutableAttributedString+Bold.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 1/23/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    
    @discardableResult
    func append(_ text: String, with font: UIFont) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: font]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    static func highlight(_ text: String, with color: UIColor, with font: UIFont? = nil) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        let paragraph = NSMutableParagraphStyle()
        paragraph.paragraphSpacing = 20
        attributedString.setAttributes([NSAttributedString.Key.backgroundColor: color], range: NSRange(location: 0, length: text.count))
        attributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraph], range: NSRange(location: 0, length: text.count))
        if let font = font {
            attributedString.addAttributes([.font: font], range: NSRange(location: 0, length: attributedString.length))
        }
        return attributedString
    }
    
    static func lineByLineHighlight(_ text: String, ranges: [NSRange], with color: UIColor, with font: UIFont? = nil) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        for range in ranges {
            attributedString.addAttributes([NSAttributedString.Key.backgroundColor: color], range: range)
        }
        if let font = font {
            attributedString.addAttributes([.font: font], range: NSRange(location: 0, length: attributedString.length))
        }
        return attributedString
    }

}
