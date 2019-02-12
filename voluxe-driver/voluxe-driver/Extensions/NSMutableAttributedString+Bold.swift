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
    
    static func highlight(_ text: String, with color: UIColor) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.backgroundColor: color])
    }

}
