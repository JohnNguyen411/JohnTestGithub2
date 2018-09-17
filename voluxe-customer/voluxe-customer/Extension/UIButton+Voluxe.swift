//
//  UIButton+Voluxe.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 4/16/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

public enum UIButtonBorderSide {
    case top, bottom, left, right
}

extension UIButton {
    
    func addUppercasedCharacterSpacing() {
        self.addCharacterSpacing(kernValue: UILabel.uppercasedKern())
    }
    
    func addCharacterSpacing(kernValue: Float) {
        if let titleLabel = self.titleLabel, let text = titleLabel.text {
            addCharacterSpacing(kernValue: kernValue, text: text)
        }
    }
    
    func addCharacterSpacing(kernValue: Float, text: String) {
        if let titleLabel = self.titleLabel {
            let attributedText =  NSAttributedString(string: text, attributes: [NSAttributedString.Key.kern:kernValue, NSAttributedString.Key.font:titleLabel.font, NSAttributedString.Key.foregroundColor: titleLabel.textColor])
            self.setAttributedTitle(attributedText, for: UIControl.State.normal)
            
            if let highlightedTextColor = self.titleColor(for: .highlighted) {
                let highlightedAttributedText =  NSAttributedString(string: text, attributes: [NSAttributedString.Key.kern:kernValue, NSAttributedString.Key.font:titleLabel.font, NSAttributedString.Key.foregroundColor: highlightedTextColor])
                self.setAttributedTitle(highlightedAttributedText, for: UIControl.State.highlighted)
            }
        }
    }
    
    
    public func addBorder(side: UIButtonBorderSide, color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        
        switch side {
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: width)
        case .bottom:
            border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        case .right:
            border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        }
        
        self.layer.addSublayer(border)
    }
    
}
