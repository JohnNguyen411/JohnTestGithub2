//
//  VLTextField.swift
//  Valet
//
//  Created by Dylan Harris on 3/15/16.
//  Copyright © 2016 5ecret 5tar Inc. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import PhoneNumberKit

/**
 Should be created with a height of 50 in constraints of the caller. VLTextField.height
*/
class VLTextField : UIView {
    
    let textField: UITextField

    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .luxeLightGray()
        titleLabel.font = .volvoSansProRegular(size: 14)
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    static let height = 50
    
    let title: String
    
    var tapGesture: UITapGestureRecognizer
    
    var text:String {
        get {
            if let text = textField.text {
                return text
            } else {
                return ""
            }
        }
        set {
            textField.text = newValue
        }
    }
    
    var validated = false
    
    var leftPlaceholderConstraint: Constraint?
    
    convenience init(title: String, placeholder: String, kern: Float? = nil) {
        self.init(title: title, placeholder: placeholder, isPhoneNumber: false)
    }
    
    init(title:String, placeholder:String, isPhoneNumber: Bool, kern: Float? = nil) {
        
        if isPhoneNumber {
            textField = PhoneNumberTextField()
        } else {
            textField = UITextField()
        }
        textField.font = .volvoSansProMedium(size: 16)
        textField.textColor = .luxeDarkGray()
        textField.textAlignment = .right
        
        if let kern = kern {
            textField.defaultTextAttributes
                .updateValue(kern, forKey: NSAttributedString.Key.kern)
        }
        self.title = title
        
        //make the tap area huge for selecting the textField
        self.tapGesture = UITapGestureRecognizer(target: self.textField, action: #selector(UIResponder.becomeFirstResponder))
        
        super.init(frame: .zero)
        
        backgroundColor = .white
        textField.placeholder = placeholder
        
        addSubview(textField)
        
        titleLabel.text = title
        addSubview(titleLabel)
        
        applyConstraints()
        
        self.addGestureRecognizer(self.tapGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyConstraints() {
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self).offset(15)
            make.top.equalTo(self).offset(18)
            make.bottom.equalTo(self).offset(-18)
        }
        
        textField.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(self).offset(-15)
            make.top.equalTo(titleLabel)
            make.bottom.equalTo(titleLabel)
            leftPlaceholderConstraint = make.leftMargin.equalTo(titleLabel.snp.right).offset(5).constraint
        }
    }
    
    func applyErrorState() {
        textField.textColor = .red
        titleLabel.textColor = .red
    }
    
    func resetErrorState() {
        titleLabel.textColor = ColorDefinitions.lightGray
        textField.textColor = ColorDefinitions.lightGray
    }
    
    /**
     If you want to override the becomeFirstResponder and make the text view do something else
    */
    func replaceTapGestureWith(tapGesture: UITapGestureRecognizer) {
        removeGestureRecognizer(self.tapGesture)
        self.tapGesture = tapGesture
        addGestureRecognizer(self.tapGesture)
        
        //prevent textField from grabbing focus and opening keyboard
        textField.isUserInteractionEnabled = false
    }
    
    func hideLabels() {
//        leftPlaceholderConstraint?.uninstall()
        
        titleLabel.snp.updateConstraints { (make) in
            make.left.equalTo(self).offset(-30)
        }
        
        textField.snp.updateConstraints { (make) in
            make.right.equalTo(self).offset(-60) //this number doesn't really make sense...the textField is oddly coupled with titleLabel via it's left edge constraint. probably snapkit bug
        }

    }
    
    func showLabels() {
        titleLabel.snp.updateConstraints { (make) in
            make.left.equalTo(self).offset(15)
        }
        
        textField.snp.updateConstraints { (make) in
            make.right.equalTo(self).offset(-15)
        }
    }
}
