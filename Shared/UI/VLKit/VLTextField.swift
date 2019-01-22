//
//  VLTextField.swift
//  Valet
//
//  Created by Dylan Harris on 3/15/16.
//  Copyright © 2016 5ecret 5tar Inc. All rights reserved.
//

import Foundation
import UIKit
import FlagPhoneNumber

/**
 Should be created with a height of 50 in constraints of the caller. VLTextField.height
*/
class VLTextField : UIView {
    
    var titleLeadingAnchor: NSLayoutConstraint?
    var fieldtrailingAnchor: NSLayoutConstraint?
    
    let textField: UITextField

    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.Volvo.slate
        titleLabel.font = Font.Volvo.body2
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
    var textFieldIsPhoneNumber = false

    
    convenience init(title: String, placeholder: String, kern: Float? = nil) {
        self.init(title: title, placeholder: placeholder, isPhoneNumber: false)
    }
    
    init(title:String, placeholder:String, isPhoneNumber: Bool, kern: Float? = nil) {
        
        if isPhoneNumber {
            self.textFieldIsPhoneNumber = true
            let fpnTextField = FPNTextField()
            fpnTextField.flagSize = CGSize(width: 28, height: 28)
            fpnTextField.font = UIFont.systemFont(ofSize: 16)
            self.textField = fpnTextField
        } else {
            self.textFieldIsPhoneNumber = false
            textField = UITextField()
            textField.font = Font.Medium.medium
        }
        textField.textColor = UIColor.Volvo.granite
        textField.textAlignment = .right
        textField.translatesAutoresizingMaskIntoConstraints = false
        
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
        self.titleLabel.pinToSuperviewTop(spacing: 18)
        
        self.titleLeadingAnchor = self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                                           constant: 15)
        self.titleLeadingAnchor?.isActive = true
        
        self.titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                 constant: -18).isActive = true
       
        
        self.textField.pinToTopOf(peerView: titleLabel)
        
        self.fieldtrailingAnchor = self.textField.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                                            constant: 15)
        self.fieldtrailingAnchor?.isActive = true
        
        
        self.textField.bottomAnchor.constraint(equalTo: self.titleLabel.bottomAnchor).isActive = true
        self.textField.leadingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor, constant: 5).isActive = true
    }
    
    func applyErrorState() {
        textField.textColor = UIColor.Volvo.error
        titleLabel.textColor = UIColor.Volvo.error
    }
    
    func resetErrorState() {
        titleLabel.textColor = UIColor.Volvo.slate
        textField.textColor = UIColor.Volvo.slate
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
        
        self.titleLeadingAnchor?.constant = -30
        self.fieldtrailingAnchor?.constant = -60
        
        self.setNeedsUpdateConstraints()
    }
    
    func showLabels() {

        self.titleLeadingAnchor?.constant = 15
        self.fieldtrailingAnchor?.constant = -15
        
        self.setNeedsUpdateConstraints()
    }
}
