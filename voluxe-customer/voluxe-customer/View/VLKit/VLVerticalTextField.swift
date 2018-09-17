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
        textView.font = .volvoSansProMedium(size: 12)
        textView.textColor = .luxeLipstick()
        textView.numberOfLines = 1
        textView.textAlignment = .right
        textView.backgroundColor = .clear
        return textView
    }()
    
    let bottomRightLabel: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.font = .volvoSansProMedium(size: 12)
        textView.textColor = .luxeLipstick()
        textView.numberOfLines = 1
        textView.textAlignment = .right
        textView.backgroundColor = .clear
        return textView
    }()
    
    let separator = UIView()
    
    var showHidePassword = false
    
    let passwordToggleIcon = PasswordToggleVisibilityView()
    
    convenience init(title: String, placeholder: String, kern: Float? = nil) {
        self.init(title: title, placeholder: placeholder, isPhoneNumber: false, kern: kern)
    }
    
    // MARK: Initializers
    override init(title:String, placeholder:String, isPhoneNumber: Bool, kern: Float? = nil) {
        super.init(title: title, placeholder: placeholder, isPhoneNumber: isPhoneNumber, kern: kern)
        
        backgroundColor = .clear
        textField.placeholder = nil
        
        textField.textAlignment = .left
        titleLabel.textAlignment = .left
        
        titleLabel.textColor = .luxeCobaltBlue()
        
        textField.font = .volvoSansProRegular(size: 14)
        titleLabel.font = .volvoSansProMedium(size: 12)
        
        var placeholderAttributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont.volvoSansProRegular(size: 14), NSAttributedString.Key.foregroundColor: UIColor.luxeLightGray()]
        
        if let kern = kern {
            placeholderAttributes[NSAttributedString.Key.kern] = kern
            textField.defaultTextAttributes
                .updateValue(kern, forKey: NSAttributedString.Key.kern)
        }
        
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: placeholderAttributes)

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

        textField.snp.updateConstraints { (make) -> Void in
            make.right.equalToSuperview().offset(-sizeThatFits.width)
        }
        
        rightLabel.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview()
            make.bottom.equalTo(textField.snp.bottom)
            make.height.equalTo(20)
            make.width.equalTo(sizeThatFits.width+20)
        }
        
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
        
        titleLabel.snp.updateConstraints { (make) -> Void in
            make.right.equalToSuperview().offset(-sizeThatFits.width)
        }
        
        bottomRightLabel.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview()
            make.top.equalTo(titleLabel.snp.top)
            make.height.equalTo(sizeThatFits.height)
            make.width.equalTo(sizeThatFits.width+20)
        }
        
        if let actionBlock = actionBlock {
            setRightActionBlock {
                actionBlock()
            }
        }
    }
    
    
    func setShowHidePassword(showHidePassword: Bool) {
        self.textField.keyboardType = .asciiCapable
        self.showHidePassword = showHidePassword
        if showHidePassword && passwordToggleIcon.superview == nil {
            
            self.addSubview(passwordToggleIcon)
            passwordToggleIcon.snp.makeConstraints { (make) -> Void in
                make.right.equalToSuperview()
                make.bottom.equalTo(textField.snp.bottom)
                make.height.equalTo(20)
                make.width.equalTo(30)
            }
            passwordToggleIcon.delegate = self
            passwordToggleIcon.tintColor = .luxeCobaltBlue()
            
        } else if !showHidePassword && passwordToggleIcon.superview == nil {
            passwordToggleIcon.removeFromSuperview()
        }
    }
    
    override func applyConstraints() {
        textField.snp.makeConstraints { (make) -> Void in
            make.left.right.equalToSuperview()
            make.top.equalTo(self)
            make.height.equalTo(25)
        }
       
        separator.backgroundColor = .luxeCobaltBlue()
        addSubview(separator)
        
        separator.snp.makeConstraints { (make) -> Void in
            make.left.right.equalToSuperview()
            make.top.equalTo(textField.snp.bottom).offset(1)
            make.height.equalTo(1)
        }
        
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.left.right.equalToSuperview()
            make.top.equalTo(separator.snp.bottom).offset(5)
        }
    }
    
    override func applyErrorState() {
        textField.textColor = .luxeRed()
        titleLabel.textColor = .luxeRed()
        separator.backgroundColor = .luxeRed()
        backgroundColor = .clear
    }

    override func resetErrorState() {
        titleLabel.text = self.title
        titleLabel.textColor = .luxeCobaltBlue()
        textField.textColor = .luxeCobaltBlue()
        separator.backgroundColor = .luxeCobaltBlue()
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
