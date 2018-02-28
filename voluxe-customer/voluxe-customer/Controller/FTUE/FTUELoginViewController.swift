//
//  FTUELoginViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 10/31/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import RealmSwift

class FTUELoginViewController: FTUEChildViewController, FTUEProtocol, UITextFieldDelegate {
    
    let emailTextField = VLVerticalTextField(title: .EmailAddress, placeholder: .EmailPlaceholder)
    let passwordTextField = VLVerticalTextField(title: .Password, placeholder: "••••••••")
    
    var loginInProgress = false
    var realm : Realm?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.accessibilityIdentifier = "volvoIdTextField"
        passwordTextField.accessibilityIdentifier = "volvoPwdTextField"
        
        emailTextField.textField.autocorrectionType = .no
        passwordTextField.textField.autocorrectionType = .no
        passwordTextField.textField.isSecureTextEntry = true
        
        emailTextField.textField.keyboardType = .emailAddress
        
        emailTextField.textField.returnKeyType = .next
        passwordTextField.textField.returnKeyType = .done
        
        emailTextField.textField.delegate = self
        passwordTextField.textField.delegate = self
        
        emailTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        setupViews()
        
    }
    
    func setupViews() {
        
        self.view.addSubview(emailTextField)
        self.view.addSubview(passwordTextField)
        
        emailTextField.snp.makeConstraints { (make) -> Void in
            make.left.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(80)
        }
        
        passwordTextField.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(emailTextField)
            make.top.equalTo(emailTextField.snp.bottom)
            make.height.equalTo(80)
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
    
    func isPasswordValid(password: String?) -> Bool {
        guard let password = password else {
            return false
        }
        if password.isEmpty || password.count < 8 {
            return false
        }
        
        return true
    }
    
    override func checkTextFieldsValidity() -> Bool {
        let enabled = isEmailValid(email: emailTextField.textField.text) && isPasswordValid(password: passwordTextField.textField.text)
        canGoNext(nextEnabled: enabled)
        return enabled
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            passwordTextField.textField.becomeFirstResponder()
        } else {
            if checkTextFieldsValidity() {
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
    
    //MARK: FTUEStartViewController
    func didSelectPage() {
        emailTextField.textField.becomeFirstResponder()
        canGoNext(nextEnabled: false)
    }
    
    func nextButtonTap() -> Bool {
        if loginInProgress {
            return false
        }
        if let customer = UserManager.sharedInstance.getCustomer() {
            return true
        }
        
        showLoading(loading: true)
        
        guard let email = emailTextField.textField.text else { return false }
        guard let password = passwordTextField.textField.text else { return false }
        
        CustomerAPI().login(email: email, password: password).onSuccess { result in
            if let tokenObject = result?.data?.result {
                if let customerId = tokenObject.customerId {
                    // Get Customer object with ID
                    UserManager.sharedInstance.loginSuccess(token: tokenObject.token)
                    CustomerAPI().getCustomer(id: customerId).onSuccess { result in
                        if let customer = result?.data?.result {
                            if let realm = self.realm {
                                try? realm.write {
                                    realm.deleteAll()
                                    realm.add(customer)
                                }
                            }
                            UserManager.sharedInstance.setCustomer(customer: customer)
                            if customer.phoneNumberVerified {
                                // load main
                                self.loadMainScreen()
                                return
                            } else {
                                self.showLoading(loading: false)
                                _ = self.nextButtonTap()
                            }
                        }
                    }
                }
            }
            self.showLoading(loading: false)
            }.onFailure { error in
                // todo show error
                self.showLoading(loading: false)
        }
        
        return true
    }
}
