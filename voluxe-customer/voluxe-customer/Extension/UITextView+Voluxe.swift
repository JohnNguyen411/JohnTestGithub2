//
//  UITextView+Voluxe.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 7/9/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

extension UITextView {
    
    func lineSpacing(lineSpacing: CGFloat) {
        if let labelText = text, labelText.count > 0 {
            
            let paragraphStyle = NSMutableParagraphStyle()
            //line height size
            paragraphStyle.lineSpacing = lineSpacing
            paragraphStyle.alignment = self.textAlignment
            
            if let attributedText = self.attributedText {
                let attributedString = NSMutableAttributedString(attributedString: attributedText)
                attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
                self.attributedText = attributedString
            } else {
                let attributedString = NSMutableAttributedString(string: labelText)
                attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
                self.attributedText = attributedString
            }
        }
    }
    
    func volvoProLineSpacing() {
        self.lineSpacing(lineSpacing: 4.0)
    }
}
