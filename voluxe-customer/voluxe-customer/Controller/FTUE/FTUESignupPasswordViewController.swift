//
//  FTUESignupPasswordViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 2/27/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import RealmSwift

class FTUESignupPasswordViewController: FTUEChildViewController, FTUEProtocol, UITextFieldDelegate {
    
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
    
    var loginInProgress = false
    var realm : Realm?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        volvoPwdTextField.accessibilityIdentifier = "volvoPwdTextField"
        volvoPwdConfirmTextField.accessibilityIdentifier = "volvoPwdConfirmTextField"
        
        volvoPwdTextField.textField.autocorrectionType = .no
        volvoPwdConfirmTextField.textField.autocorrectionType = .no
        
        volvoPwdTextField.textField.isSecureTextEntry = true
        volvoPwdConfirmTextField.textField.isSecureTextEntry = true
        
        volvoPwdTextField.textField.returnKeyType = .next
        volvoPwdConfirmTextField.textField.returnKeyType = .done
        
        volvoPwdTextField.textField.delegate = self
        volvoPwdConfirmTextField.textField.delegate = self
        
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
            make.height.equalTo(30)
        }
        
        passwordConditionLabel.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(passwordLabel)
            make.top.equalTo(passwordLabel.snp.bottom)
            make.height.equalTo(30)
        }
        
        volvoPwdTextField.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(passwordConditionLabel)
            make.top.equalTo(passwordConditionLabel.snp.bottom).offset(20)
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
        if password.isEmpty || password.count < 8 {
            return false
        }
        
        return password.containsNumber() && password.containsLetter()
    }
    
    
    override func checkTextFieldsValidity() -> Bool {
        let enabled = isPasswordValid(password: volvoPwdTextField.textField.text) && isPasswordValid(password: volvoPwdConfirmTextField.textField.text) && String.areSimilar(stringOne: volvoPwdTextField.textField.text, stringTwo: volvoPwdConfirmTextField.textField.text)
        canGoNext(nextEnabled: enabled)
        return enabled
    }
    
    private func onSignupError() {
        //todo show error message
        self.showLoading(loading: false)
    }
    
    func showLoading(loading: Bool) {
        if loginInProgress == loading {
            return
        }
        loginInProgress = loading
        if loading {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        } else {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            volvoPwdConfirmTextField.textField.becomeFirstResponder()
        } else {
            if checkTextFieldsValidity() {
                //todo CREATE CUSTOMER HERE AND THEN ADD CAR
                self.goToNext()
            } else {
                // show error
            }
        }
        return false
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        _ = checkTextFieldsValidity()
    }
    
    //MARK: FTUEStartViewController
    func didSelectPage() {
        volvoPwdTextField.textField.becomeFirstResponder()
        canGoNext(nextEnabled: false)
    }
    
    func nextButtonTap() -> Bool {
        let signupCustomer = FTUEViewController.signupCustomer
        
        if loginInProgress {
            return false
        }
        
        showLoading(loading: true)

        if UserManager.sharedInstance.getCustomer() != nil {
            
            if UserManager.sharedInstance.getAccessToken() != nil {
                self.showLoading(loading: false)
                self.loadMainScreen()
            } else {
                loginUser(email: signupCustomer.email!, password: volvoPwdConfirmTextField.textField.text!)
            }
            return false
        }
        
        //TODO: NOW => Create account
        // HANDLE LOADING AND ERRORS
        // CALL LOGIN AND REDIRECT
        CustomerAPI().signup(email: signupCustomer.email!, password: volvoPwdConfirmTextField.textField.text!, firstName: signupCustomer.firstName!, lastName: signupCustomer.lastName!, phoneNumber: signupCustomer.phoneNumber!).onSuccess { result in
            if let customer = result?.data?.result {
                if let realm = self.realm {
                    try? realm.write {
                        realm.deleteAll()
                        realm.add(customer)
                    }
                }
                UserManager.sharedInstance.setCustomer(customer: customer)
                self.loginUser(email: signupCustomer.email!, password: self.volvoPwdConfirmTextField.textField.text!)
            } else {
                self.onSignupError()
            }
            }.onFailure { error in
                self.onSignupError()
        }
        
        return false
    }
    
    func loginUser(email: String, password: String) {
        CustomerAPI().login(email: email, password: password).onSuccess { result in
            if let tokenObject = result?.data?.result, let _ = tokenObject.customerId {
                // Get Customer object with ID
                UserManager.sharedInstance.loginSuccess(token: tokenObject.token)
                self.showLoading(loading: false)
                self.loadMainScreen()
            } else {
                self.onSignupError()
            }
            }.onFailure { error in
                self.onSignupError()
        }
    }
    
    
}
