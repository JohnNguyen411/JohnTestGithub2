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
    
    static let verticalHeight = 80
    
    let rightLabel: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = Font.Small.medium
        textView.textColor = UIColor.Volvo.brightBlue
        textView.numberOfLines = 1
        textView.textAlignment = .right
        textView.backgroundColor = .clear
        return textView
    }()
    
    let bottomRightLabel: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = UIColor.Volvo.error
        textView.font = Font.Small.medium
        textView.numberOfLines = 1
        textView.textAlignment = .right
        textView.backgroundColor = .clear
        return textView
    }()
    
    let separator = UIView()
    
    var showPasswordToggleIcon = false {
        didSet {
            self.textField.rightView = showPasswordToggleIcon ? self.passwordToggleIcon : nil
        }
    }

    // Autolayout cannot determine the intrinsic size of the
    // toggle view so for the UITextField to properly manage
    // it as a .rightView, a size has to be given to it.
    private let passwordToggleIcon: PasswordToggleVisibilityView = {
        let view = PasswordToggleVisibilityView()
        view.bounds = CGRect(x: 0, y: 0, width: 30, height: 20)
        view.tintColor = UIColor.Volvo.brightBlue
        return view
    }()

    // MARK: Initializers

    convenience init(title: String, placeholder: String, kern: Float? = nil) {
        self.init(title: title, placeholder: placeholder, isPhoneNumber: false, kern: kern)
    }

    override init(title:String, placeholder:String, isPhoneNumber: Bool, kern: Float? = nil) {
        super.init(title: title, placeholder: placeholder, isPhoneNumber: isPhoneNumber, kern: kern)
        
        separator.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        textField.placeholder = nil

        // configure for Password AutoFill
        // note that this means the "show password" button
        // is not visible until the field has been tapped,
        // and then only if the suggested password is not used
        textField.keyboardType = .asciiCapable
        textField.clearButtonMode = .never
        textField.rightViewMode = .whileEditing
        passwordToggleIcon.delegate = self
        
        textField.textAlignment = .left
        titleLabel.textAlignment = .left
        
        titleLabel.textColor = UIColor.Volvo.brightBlue
        titleLabel.font = Font.Small.medium

        if !isPhoneNumber {
            textField.font = Font.Volvo.body2
            
            var placeholderAttributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: Font.Volvo.body2, NSAttributedString.Key.foregroundColor: UIColor.Volvo.slate]
            
            if let kern = kern {
                placeholderAttributes[NSAttributedString.Key.kern] = kern
                textField.defaultTextAttributes
                    .updateValue(kern, forKey: NSAttributedString.Key.kern)
            }
            
            textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: placeholderAttributes)
        } else {
            textField.font = UIFont.systemFont(ofSize: 14)
            
            var placeholderAttributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.Volvo.slate]
            
            if let kern = kern {
                placeholderAttributes[NSAttributedString.Key.kern] = kern
                textField.defaultTextAttributes
                    .updateValue(kern, forKey: NSAttributedString.Key.kern)
            }
            
            textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: placeholderAttributes)
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setRightButtonText(rightButtonText: String, actionBlock: (()->())?) {
        rightLabel.text = rightButtonText

        if rightLabel.superview == nil {
            addSubview(rightLabel)
        }
        
        let sizeThatFits = rightLabel.sizeThatFits(CGSize(width: 150, height: 20))
        
        self.fieldtrailingAnchor?.constant = -sizeThatFits.width
        
        self.rightLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.rightLabel.bottomAnchor.constraint(equalTo: self.textField.bottomAnchor).isActive = true
        self.rightLabel.widthAnchor.constraint(equalToConstant: sizeThatFits.width + 20).isActive = true
        self.rightLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.setNeedsUpdateConstraints()
        
        if let actionBlock = actionBlock {
            setRightActionBlock {
                actionBlock()
            }
        }
    }
    
    func setBottomRightText(bottomRightText: String, actionBlock: (()->())?) {
        bottomRightLabel.text = bottomRightText
        
        if bottomRightLabel.superview == nil {
            addSubview(bottomRightLabel)
        }
        
        let sizeThatFits = bottomRightLabel.sizeThatFits(CGSize(width: 150, height: 20))
        
        self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -sizeThatFits.width).isActive = true
        
        self.bottomRightLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.bottomRightLabel.topAnchor.constraint(equalTo: self.titleLabel.topAnchor).isActive = true
        self.bottomRightLabel.heightAnchor.constraint(equalToConstant: sizeThatFits.height).isActive = true
        self.bottomRightLabel.widthAnchor.constraint(equalToConstant: sizeThatFits.width + 20).isActive = true
        
        self.setNeedsUpdateConstraints()
        
        if let actionBlock = actionBlock {
            setRightActionBlock {
                actionBlock()
            }
        }
    }
    
    override func applyConstraints() {
        
        self.fieldtrailingAnchor = self.textField.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        self.fieldtrailingAnchor?.isActive = true
        
        self.textField.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.textField.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        separator.backgroundColor = UIColor.Volvo.brightBlue
        addSubview(separator)
        
        self.separator.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.separator.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.separator.heightAnchor.constraint(equalToConstant: 1).isActive = true

        if textFieldIsPhoneNumber {
            self.separator.topAnchor.constraint(equalTo: self.textField.bottomAnchor, constant: 5).isActive = true
        } else {
            self.separator.topAnchor.constraint(equalTo: self.textField.bottomAnchor, constant: 4).isActive = true
        }
        
        self.titleLeadingAnchor = self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        self.titleLeadingAnchor?.isActive = true
        
        self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.titleLabel.topAnchor.constraint(equalTo: self.separator.bottomAnchor, constant: 7).isActive = true
        
        self.setNeedsUpdateConstraints()

    }
    
    override func applyErrorState() {
        textField.textColor = UIColor.Volvo.error
        titleLabel.textColor = UIColor.Volvo.error
        separator.backgroundColor = UIColor.Volvo.error
        backgroundColor = .clear
    }

    override func resetErrorState() {
        titleLabel.text = self.title
        titleLabel.textColor = UIColor.Volvo.brightBlue
        textField.textColor = UIColor.Volvo.brightBlue
        separator.backgroundColor = UIColor.Volvo.brightBlue
        backgroundColor = .clear
    }

    /**
     Can use an action block that takes the place of a target/action
     */
    private var rightActionBlock:(()->())?
    
    func setRightActionBlock(actionBlock: @escaping (()->())) {
        self.rightActionBlock = actionBlock
        
        rightLabel.isUserInteractionEnabled = true
        let rightLabelTap = UITapGestureRecognizer(target: self, action: #selector(self.runActionBlock))
        rightLabel.addGestureRecognizer(rightLabelTap)
        
    }
    
    private var bottomRightActionBlock:(()->())?

    func setBottomRightActionBlock(actionBlock: @escaping (()->())) {
        self.bottomRightActionBlock = actionBlock
        
        bottomRightLabel.isUserInteractionEnabled = true
        let rightLabelTap = UITapGestureRecognizer(target: self, action: #selector(self.runBottomActionBlock))
        bottomRightLabel.addGestureRecognizer(rightLabelTap)
        
    }
    
    @objc internal func runActionBlock() {
        rightActionBlock?()
    }
    
    @objc internal func runBottomActionBlock() {
        bottomRightActionBlock?()
    }
}

// MARK: PasswordToggleVisibilityDelegate

extension VLVerticalTextField: PasswordToggleVisibilityDelegate {

    func viewWasToggled(passwordToggleVisibilityView: PasswordToggleVisibilityView, isSelected selected: Bool) {
        
        // hack to fix a bug with padding when switching between secureTextEntry state
        let hackString = self.textField.text
        self.textField.text = " "
        self.textField.text = hackString
        
        // hack to save our correct font.  The order here is VERY finicky
        self.textField.isSecureTextEntry = !selected

        if selected {
            self.textField.keyboardType = .asciiCapable
        }
        
        self.textField.text = " "
        self.textField.text = hackString

        if let selectedRange = textField.selectedTextRange {
            let cursorPosition = textField.offset(from: textField.beginningOfDocument, to: selectedRange.start)
            if let textposition = textField.position(from: textField.beginningOfDocument, offset: cursorPosition) {
                self.textField.selectedTextRange = textField.textRange(from: textposition, to: textposition)
            }
        }

    }
}
