//
//  FTUESignupEmailPhoneViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 2/27/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
import PhoneNumberKit

class FTUESignupEmailPhoneViewController: FTUEChildViewController, FTUEProtocol, UITextFieldDelegate {
    
    let emailTextField = VLVerticalTextField(title: .EmailAddress, placeholder: .EmailPlaceholder)
    
    let phoneNumberTextField = VLVerticalTextField(title: .MobilePhoneNumber, placeholder: .MobilePhoneNumber_Placeholder, isPhoneNumber: true)
    let phoneNumberKit = PhoneNumberKit()
    
    let phoneNumberLabel: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.text = .MobilePhoneNumberExplain
        textView.font = .volvoSansLight(size: 18)
        textView.textColor = .luxeDarkGray()
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    let phoneNumberConfirmLabel: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.font = .volvoSansLight(size: 12)
        textView.textColor = .luxeDarkGray()
        textView.text = .MobilePhoneNumberConfirm
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let phoneNumberTF: PhoneNumberTextField = phoneNumberTextField.textField as! PhoneNumberTextField
        phoneNumberTF.maxDigits = 10
        
        phoneNumberTextField.accessibilityIdentifier = "phoneNumberTextField"
        emailTextField.accessibilityIdentifier = "emailTextField"
        
        emailTextField.textField.autocorrectionType = .no
        phoneNumberTextField.textField.autocorrectionType = .no
        
        phoneNumberTextField.textField.keyboardType = .phonePad
        emailTextField.textField.keyboardType = .emailAddress
        
        emailTextField.textField.returnKeyType = .next
        phoneNumberTextField.textField.returnKeyType = .done
        
        emailTextField.textField.delegate = self
        phoneNumberTextField.textField.delegate = self

        phoneNumberTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        setupViews()
        
    }
    
    func setupViews() {
        
        self.view.addSubview(phoneNumberLabel)
        self.view.addSubview(phoneNumberConfirmLabel)
        self.view.addSubview(emailTextField)
        self.view.addSubview(phoneNumberTextField)

        let sizeThatFits = phoneNumberLabel.sizeThatFits(CGSize(width: view.frame.width-40, height: CGFloat(MAXFLOAT)))
        
        phoneNumberLabel.snp.makeConstraints { (make) -> Void in
            make.left.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(sizeThatFits)
        }
        
        emailTextField.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(15)
            make.height.equalTo(VLVerticalTextField.height)
        }
        
        phoneNumberTextField.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(emailTextField.snp.bottom).offset(15)
            make.height.equalTo(VLVerticalTextField.height)
        }
        
        phoneNumberConfirmLabel.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(phoneNumberLabel)
            make.top.equalTo(phoneNumberTextField.snp.bottom)
            make.height.equalTo(20)
        }
    }
    
    //MARK: Validation methods
    
    func isEmailValid(email: String?) -> Bool {
        guard let email = email else {
            return false
        }
        
        if email.isEmpty {
            return false
        }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func isPhoneNumberValid(phoneNumber: String?) -> Bool {
        guard let phoneNumber = phoneNumber else {
            return false
        }
        
        guard let textField = phoneNumberTextField.textField as? PhoneNumberTextField else {
            return false
        }
        
        do {
            let _ = try phoneNumberKit.parse(phoneNumber, withRegion: textField.currentRegion, ignoreType: true)
            return true
        } catch {
            return false
        }
        
    }
    
    override func checkTextFieldsValidity() -> Bool {
        let enabled = isEmailValid(email: emailTextField.textField.text) && isPhoneNumberValid(phoneNumber: phoneNumberTextField.textField.text)
        canGoNext(nextEnabled: enabled)
        return enabled
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        _ = checkTextFieldsValidity()
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            phoneNumberTextField.textField.becomeFirstResponder()
        } else {
            if checkTextFieldsValidity() {
                self.goToNext()
            } else {
                // show error
            }
        }
        return false
    }
    
    //MARK: FTUEStartViewController
    func didSelectPage() {
        emailTextField.textField.becomeFirstResponder()
        canGoNext(nextEnabled: false)
    }
    
    func nextButtonTap() -> Bool {
        FTUEViewController.signupCustomer.email = emailTextField.textField.text
        FTUEViewController.signupCustomer.phoneNumber = phoneNumberTextField.textField.text
        return true
    }
}
