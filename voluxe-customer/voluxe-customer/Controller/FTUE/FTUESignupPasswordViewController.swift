//
//  FTUESignupPasswordViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 2/27/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

class FTUESignupPasswordViewController: FTUEChildViewController, FTUEProtocol {
    
    let passwordLabel: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.text = .CreatePassword
        textView.font = .volvoSansLight(size: 18)
        textView.textColor = .luxeDarkGray()
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    let passwordConditionLabel: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.font = .volvoSansLightBold(size: 12)
        textView.textColor = .luxeDarkGray()
        textView.text = .PasswordCondition
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    let volvoPwdTextField = VLVerticalTextField(title: .Password, placeholder: "••••••••")
    let volvoPwdConfirmTextField = VLVerticalTextField(title: .RepeatPassword, placeholder: "••••••••")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        volvoPwdTextField.accessibilityIdentifier = "volvoPwdTextField"
        volvoPwdConfirmTextField.accessibilityIdentifier = "volvoPwdConfirmTextField"
        
        volvoPwdTextField.textField.autocorrectionType = .no
        volvoPwdConfirmTextField.textField.autocorrectionType = .no

        volvoPwdTextField.textField.isSecureTextEntry = true
        volvoPwdConfirmTextField.textField.isSecureTextEntry = true

        volvoPwdTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        volvoPwdConfirmTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        setupViews()
        
    }
    
    func setupViews() {
        
        self.view.addSubview(passwordLabel)
        self.view.addSubview(passwordConditionLabel)
        self.view.addSubview(volvoPwdTextField)
        self.view.addSubview(volvoPwdConfirmTextField)

        passwordLabel.snp.makeConstraints { (make) -> Void in
            make.left.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(80)
        }
        
        passwordConditionLabel.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(passwordLabel)
            make.top.equalTo(passwordLabel.snp.bottom)
            make.height.equalTo(80)
        }
        
        volvoPwdTextField.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(passwordConditionLabel)
            make.top.equalTo(passwordConditionLabel.snp.bottom)
            make.height.equalTo(80)
        }
        
        volvoPwdConfirmTextField.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(volvoPwdTextField)
            make.top.equalTo(volvoPwdTextField.snp.bottom)
            make.height.equalTo(80)
        }
    }
    
    //MARK: Validation methods
    
    func isPasswordValid(password: String?) -> Bool {
        guard let password = password else {
            return false
        }
        if password.isEmpty || password.count < 7 {
            return false
        }
        
        return containsNumber(string: password) && containsLetter(string: password)
    }
    
    func containsNumber(string: String) -> Bool {
        let decimalCharacters = CharacterSet.decimalDigits
        
        let decimalRange = string.rangeOfCharacter(from: decimalCharacters)
        
        if decimalRange != nil {
            return true
        }
        return false
    }
    
    func containsLetter(string: String) -> Bool {
        let decimalCharacters = CharacterSet.letters
        
        let decimalRange = string.rangeOfCharacter(from: decimalCharacters)
        
        if decimalRange != nil {
            return true
        }
        return false
    }
    
    func areSimilar(passwordOne: String?, passwordTwo: String?) -> Bool {
        guard let passwordOne = passwordOne else {
            return false
        }
        
        guard let passwordTwo = passwordTwo else {
            return false
        }
        
        return passwordOne == passwordTwo
    }
    
    override func checkTextFieldsValidity() {
        canGoNext(nextEnabled: isPasswordValid(password: volvoPwdTextField.textField.text) && isPasswordValid(password: volvoPwdConfirmTextField.textField.text) && areSimilar(passwordOne: volvoPwdTextField.textField.text, passwordTwo: volvoPwdConfirmTextField.textField.text))
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        checkTextFieldsValidity()
    }
    
    //MARK: FTUEStartViewController
    func didSelectPage() {
        volvoPwdTextField.textField.becomeFirstResponder()
        canGoNext(nextEnabled: false)
    }
}
