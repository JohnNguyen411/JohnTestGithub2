//
//  UIButton+Voluxe.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 4/16/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

extension UIButton {
    
    func addCharacterSpacing(kernValue: Float) {
        if let titleLabel = self.titleLabel, let text = titleLabel.text {
            let attributedText =  NSAttributedString(string: text, attributes: [NSAttributedStringKey.kern:kernValue, NSAttributedStringKey.font:titleLabel.font, NSAttributedStringKey.foregroundColor: titleLabel.textColor])
            self.setAttributedTitle(attributedText, for: UIControlState.normal)
            
            if let highlightedTextColor = self.titleColor(for: .highlighted) {
                let highlightedAttributedText =  NSAttributedString(string: text, attributes: [NSAttributedStringKey.kern:kernValue, NSAttributedStringKey.font:titleLabel.font, NSAttributedStringKey.foregroundColor: highlightedTextColor])
                self.setAttributedTitle(highlightedAttributedText, for: UIControlState.highlighted)
            }
        }
        
    }
    
}
