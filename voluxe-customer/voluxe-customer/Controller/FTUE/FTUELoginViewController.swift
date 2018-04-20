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

class FTUELoginViewController: FTUEChildViewController, UITextFieldDelegate {
    
    let emailTextField = VLVerticalTextField(title: .EmailAddress, placeholder: .EmailPlaceholder)
    let passwordTextField = VLVerticalTextField(title: .Password, placeholder: "••••••••")
    let forgotPassword: VLButton
    
    var loginInProgress = false
    var realm : Realm?
    
    init() {
        forgotPassword = VLButton(type: .orangeSecondaryVerySmall, title: String.ForgotPassword.uppercased(), kern: UILabel.uppercasedKern(), eventName: AnalyticsConstants.eventClickForgotPassword, screenName: AnalyticsConstants.paramNameLoginView)
        
        super.init(screenName: AnalyticsConstants.paramNameLoginView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realm = try? Realm()
        
        emailTextField.accessibilityIdentifier = "volvoIdTextField"
        passwordTextField.accessibilityIdentifier = "volvoPwdTextField"
        
        forgotPassword.setActionBlock {
            self.navigationController?.pushViewController(FTUEPhoneNumberViewController(type: .resetPassword), animated: true)
        }
        
        emailTextField.textField.autocorrectionType = .no
        passwordTextField.textField.autocorrectionType = .no
        passwordTextField.textField.isSecureTextEntry = true
        
        emailTextField.textField.keyboardType = .emailAddress
        emailTextField.textField.autocapitalizationType = .none
        
        emailTextField.textField.returnKeyType = .next
        passwordTextField.textField.returnKeyType = .done
        
        emailTextField.textField.delegate = self
        passwordTextField.textField.delegate = self
        
        emailTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        emailTextField.textField.becomeFirstResponder()
        canGoNext(nextEnabled: false)
        
    }
    
    override func setupViews() {
        
        self.view.addSubview(emailTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(forgotPassword)
        
        emailTextField.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(80)
        }
        
        passwordTextField.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(emailTextField)
            make.top.equalTo(emailTextField.snp.bottom)
            make.height.equalTo(80)
        }
        
        forgotPassword.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(passwordTextField)
            make.centerY.equalTo(passwordTextField.snp.centerY)
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
    
    func isPasswordValid(password: String?) -> Bool {
        guard let password = password else {
            return false
        }
        if password.isEmpty || password.count < 5 {
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
                self.onRightClicked()
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
            showProgressHUD()
        } else {
            self.hideProgressHUD()
        }
    }
    
    //MARK: FTUEStartViewController
    
    override func onRightClicked(analyticEventName: String? = nil) {
        super.onRightClicked(analyticEventName: analyticEventName)
        if loginInProgress {
            return
        }
        if UserManager.sharedInstance.getCustomer() != nil {
            return
        }
        
        showLoading(loading: true)
        
        guard let email = emailTextField.textField.text else { return }
        guard let password = passwordTextField.textField.text else { return }
        
        CustomerAPI().login(email: email, password: password).onSuccess { result in
            if let tokenObject = result?.data?.result, let customerId = tokenObject.customerId {
                // Get Customer object with ID
                UserManager.sharedInstance.loginSuccess(token: tokenObject.token, customerId: String(customerId))
                UserManager.sharedInstance.tempCustomerId = customerId
                CustomerAPI().getMe().onSuccess { result in
                    if let customer = result?.data?.result {
                        if let realm = self.realm {
                            try? realm.write {
                                realm.deleteAll()
                                realm.add(customer)
                            }
                        }
                        UserManager.sharedInstance.setCustomer(customer: customer)
                        if !customer.phoneNumberVerified {
                            self.showLoading(loading: false)
                            self.appDelegate?.phoneVerificationScreen()
                            return
                        } else {
                            self.showLoading(loading: false)
                            self.appDelegate?.startApp()
                        }
                    } else {
                        self.showLoading(loading: false)
                        self.appDelegate?.phoneVerificationScreen()
                    }
                    }.onFailure { error in
                        self.onLoginError()
                }
            } else {
                self.onLoginError(error: result?.error)
            }
            }.onFailure { error in
                self.onLoginError()
        }
        
    }
    
    private func onLoginError(error: ResponseError? = nil) {
        //todo show error message
        self.showLoading(loading: false)
        
        if error?.code == "E2005" {
            self.showOkDialog(title: .Error, message: .InvalidCredentials)
        } else {
            self.showOkDialog(title: .Error, message: .GenericError)
        }
    }
}
