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
        let attributedText =  NSAttributedString(string: self.titleLabel!.text!, attributes: [NSAttributedStringKey.kern:kernValue, NSAttributedStringKey.font:self.titleLabel!.font, NSAttributedStringKey.foregroundColor:self.titleLabel!.textColor])
        self.setAttributedTitle(attributedText, for: UIControlState.normal)
        
    }
    
}
