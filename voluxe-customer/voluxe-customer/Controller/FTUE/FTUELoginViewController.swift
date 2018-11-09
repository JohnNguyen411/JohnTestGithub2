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
    let forgotPassword = VLButton(type: .orangeSecondaryVerySmall, title: String.ForgotPassword.uppercased(), kern: UILabel.uppercasedKern(), event: .forgotPassword, screen: .login)
    
    var loginInProgress = false
    var realm : Realm?
    
    init() {
        super.init(screen: .login)
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
            [weak self] in
            self?.pushViewController(FTUEPhoneNumberViewController(type: .resetPassword), animated: true)
        }

        // support autofill
        if #available(iOS 11.0, *) {
            self.emailTextField.textField.textContentType = .username
            self.passwordTextField.textField.textContentType = .password
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

        canGoNext(nextEnabled: false)        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.emailTextField.textField.becomeFirstResponder()
    }
    
    override func setupViews() {
        super.setupViews()
        
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(forgotPassword)
        
        emailTextField.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(BaseViewController.defaultTopYOffset)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(VLVerticalTextField.verticalHeight)
        }
        
        passwordTextField.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(emailTextField)
            make.top.equalTo(emailTextField.snp.bottom)
            make.height.equalTo(VLVerticalTextField.verticalHeight)
        }
        
        forgotPassword.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(passwordTextField)
            make.centerY.equalTo(passwordTextField.snp.centerY)
            make.height.equalTo(20)
        }
    }
    
    // MARK: Validation methods

    override func checkTextFieldsValidity() -> Bool {
        let enabled = String.isValid(email: emailTextField.textField.text) &&
            String.isValid(password: passwordTextField.textField.text)
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
    
    override func onRightClicked() {
        super.onRightClicked()
        if loginInProgress {
            return
        }
        if UserManager.sharedInstance.getCustomer() != nil {
            return
        }
        
        showLoading(loading: true)
        
        guard let email = emailTextField.textField.text else { return }
        guard let password = passwordTextField.textField.text else { return }
        
        CustomerAPI.login(email: email, password: password) { token, error in
            if let tokenObject = token, let customerId = tokenObject.customerId {

                // Get Customer object with ID
                UserManager.sharedInstance.loginSuccess(token: tokenObject.token, customerId: String(customerId))
                UserManager.sharedInstance.tempCustomerId = customerId
                CustomerAPI.me() { customer, error in
                    if let customer = customer {

                        if let realm = self.realm {
                            try? realm.write {
                                realm.deleteAll()
                                realm.add(customer)
                            }
                        }
                        UserManager.sharedInstance.setCustomer(customer: customer)
                        if !customer.phoneNumberVerified {
                            self.showLoading(loading: false)
                            AppController.sharedInstance.phoneVerificationScreen()
                            return
                        } else {
                            self.showLoading(loading: false)
                            AppController.sharedInstance.startApp()
                        }
                    } else {
                        self.onLoginError()
                    }
                }
            } else {
                self.onLoginError(error: error)
            }
        }
        
    }
    
    private func onLoginError(error: APIResponseError? = nil) {
        self.showLoading(loading: false)
        
        if let apiError = error?.apiError, apiError.code == Errors.ErrorCode.E2005.rawValue {
            self.showOkDialog(title: .Error, message: .InvalidCredentials, dialog: .error, screen: self.screen)
        } else {
            self.showOkDialog(title: .Error, message: .GenericError, dialog: .error, screen: self.screen)
        }
    }
}
