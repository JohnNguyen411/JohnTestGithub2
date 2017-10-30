//
//  VLVerticalTextField.swift
//  Valet
//
//  Created by Johan Giroux on 9/28/16.
//  Copyright © 2016 Luxe Valet, Inc. All rights reserved.
//

import Foundation
import UIKit

/**
 Should be created with a height of 75 in constraints of the caller. LuxeVerticalTextField.verticalHeight
 */
class VLVerticalTextField : VLTextField {

    static let verticalHeight = 75
    
    // MARK: Initializers
    override init(title:String, placeholder:String) {
        super.init(title: title, placeholder: placeholder)
        
        backgroundColor = .clear
        textField.placeholder = nil
        
        textField.textAlignment = .left
        titleLabel.textAlignment = .left
        textField.textColor = .white
        titleLabel.textColor = .white
        textField.tintColor = .white
        textField.font = Fonts.FONT_B1
        titleLabel.font = Fonts.FONT_B4
        
        /*
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSFontAttributeName: Fonts.FONT_B1, NSForegroundColorAttributeName: .white])
 */
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func applyConstraints() {
        textField.snp.makeConstraints { (make) -> Void in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(self).offset(10)
            make.height.equalTo(25)
        }
        
        let separator0 = UIView()
        separator0.backgroundColor = .white
        addSubview(separator0)
        
        separator0.snp.makeConstraints { (make) -> Void in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(textField.snp.bottom).offset(1)
            make.height.equalTo(1)
        }
        
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(separator0.snp.bottom).offset(4)
        }
    }
    
    override func applyErrorState() {
        textField.textColor = .white
        titleLabel.textColor = .red
        backgroundColor = .blue
    }

    override func resetErrorState() {
        titleLabel.text = self.title
        titleLabel.textColor = .white
        textField.textColor = .white
        backgroundColor = .clear
    }

    
}
