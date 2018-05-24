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

class FTUESignupPasswordViewController: FTUEChildViewController, UITextFieldDelegate {
    
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
        textView.font = .volvoSansProMedium(size: 11)
        textView.textColor = .luxeDarkGray()
        textView.text = .PasswordCondition
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    let volvoPwdTextField = VLVerticalTextField(title: .Password, placeholder: "••••••••", kern: 4.0)
    let volvoPwdConfirmTextField = VLVerticalTextField(title: .RepeatPassword, placeholder: "••••••••", kern: 4.0)
    
    var signupInProgress = false
    var realm : Realm?
    
    init() {
        super.init(screenName: AnalyticsConstants.paramNameSignupPasswordView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        volvoPwdTextField.accessibilityIdentifier = "volvoPwdTextField"
        volvoPwdConfirmTextField.accessibilityIdentifier = "volvoPwdConfirmTextField"
                
        volvoPwdTextField.setShowHidePassword(showHidePassword: true)
        volvoPwdConfirmTextField.setShowHidePassword(showHidePassword: true)
        
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
        
        volvoPwdTextField.textField.becomeFirstResponder()
        canGoNext(nextEnabled: false)
        
        if UserManager.sharedInstance.isLoggedIn() {
            passwordLabel.text = .UpdatePassword
        }
    }
    
    override func setupViews() {
        
        self.view.addSubview(passwordLabel)
        self.view.addSubview(passwordConditionLabel)
        self.view.addSubview(volvoPwdTextField)
        self.view.addSubview(volvoPwdConfirmTextField)
        
        passwordLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        passwordConditionLabel.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(passwordLabel)
            make.top.equalTo(passwordLabel.snp.bottom).offset(-5)
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
        guard let password = password else { return false }
        
        if password.isEmpty || password.count < 8 {
            return false
        }
        //Matches
        return password.containsNumber() && password.containsLetter()
        
    }
    
    private func containsUnauthorizedChars(password: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^(?=.*[a-zA-Z])(?=.*[0-9])[a-zA-Z0-9@$!%*?&]{8,60}")
        let range = NSMakeRange(0, password.utf16.count)
        let matchRange = regex.rangeOfFirstMatch(in: password, options: .reportProgress, range: range)
        let valid = matchRange == range
        return !valid
    }
    
    override func checkTextFieldsValidity() -> Bool {
        let enabled = isPasswordValid(password: volvoPwdTextField.textField.text) && isPasswordValid(password: volvoPwdConfirmTextField.textField.text) && String.areSimilar(stringOne: volvoPwdTextField.textField.text, stringTwo: volvoPwdConfirmTextField.textField.text)
        canGoNext(nextEnabled: enabled)
        return enabled
    }
    
    private func onSignupError(error: Errors? = nil) {
        self.showLoading(loading: false)
        
        if let apiError = error?.apiError {
            if apiError.getCode() == .E5001 {
                self.showOkDialog(title: .Error, message: .AccountAlreadyExist, completion: {
                    self.loadLandingPage()
                }, analyticDialogName: AnalyticsConstants.paramNameErrorDialog, screenName: self.screenName)
            } else if apiError.getCode() == .E4012 {
                self.showOkDialog(title: .Error, message: .InvalidVerificationCode, completion: {
                    self.navigationController?.popViewController(animated: true)
                }, analyticDialogName: AnalyticsConstants.paramNameErrorDialog, screenName: self.screenName)
            }
        } else {
            self.showOkDialog(title: .Error, message: .GenericError, analyticDialogName: AnalyticsConstants.paramNameErrorDialog, screenName: self.screenName)
        }
        
    }
    
    func showLoading(loading: Bool) {
        if signupInProgress == loading {
            return
        }
        signupInProgress = loading
        if loading {
            showProgressHUD()
        } else {
            self.hideProgressHUD()
        }
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            volvoPwdConfirmTextField.textField.becomeFirstResponder()
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
    
    //MARK: FTUEStartViewController
    
    override func onRightClicked(analyticEventName: String? = nil) {
        super.onRightClicked(analyticEventName: analyticEventName)
        let signupCustomer = UserManager.sharedInstance.signupCustomer
        
        if signupInProgress {
            return
        }
        
        if let password = volvoPwdConfirmTextField.textField.text, containsUnauthorizedChars(password: password) {
            self.showOkDialog(title: .Error, message: .PasswordUnauthorizedChars, analyticDialogName: AnalyticsConstants.paramNameErrorDialog, screenName: self.screenName)
            return
        }
        
        showLoading(loading: true)
        
        weak var weakSelf = self
        
        // if user is logged in, it's a password update
        if let code = UserManager.sharedInstance.signupCustomer.verificationCode,
            let password = volvoPwdConfirmTextField.textField.text, let customerId = UserManager.sharedInstance.customerId(),
            signupCustomer.email == nil, UserManager.sharedInstance.isLoggedIn() {
            CustomerAPI().passwordChange(customerId: customerId, code: code, password: password).onSuccess { result in
                VLAnalytics.logEventWithName(AnalyticsConstants.eventApiPasswordChangeSuccess, screenName: weakSelf?.screenName ?? nil)
                weakSelf?.showLoading(loading: false)
                weakSelf?.navigationController?.popToRootViewController(animated: true)
                }.onFailure { error in
                    VLAnalytics.logErrorEventWithName(AnalyticsConstants.eventApiPasswordChangeFail, screenName: weakSelf?.screenName, error: error)
                    weakSelf?.showOkDialog(title: .Error, message: .GenericError, analyticDialogName: AnalyticsConstants.paramNameErrorDialog, screenName: weakSelf?.screenName ?? nil)
                    weakSelf?.showLoading(loading: false)
                }
            
            return
        }
        
        // if no access token, no temp email, no cust id, and a phone number, it's a reset password
        if let code = UserManager.sharedInstance.signupCustomer.verificationCode,
            let password = volvoPwdConfirmTextField.textField.text,
            let phoneNumber = UserManager.sharedInstance.signupCustomer.phoneNumber,
            UserManager.sharedInstance.customerId() == nil, signupCustomer.email == nil, !UserManager.sharedInstance.isLoggedIn() {
            CustomerAPI().passwordResetConfirm(phoneNumber: phoneNumber, code: code, password: password).onSuccess { result in
                weakSelf?.showLoading(loading: false)
                VLAnalytics.logEventWithName(AnalyticsConstants.eventApiPasswordResetConfirmSuccess, screenName: weakSelf?.screenName)
                // password successfully updated, login the user
                weakSelf?.loginUser(phoneNumber: phoneNumber, password: password)
                
                }.onFailure { error in
                    weakSelf?.showLoading(loading: false)
                    VLAnalytics.logErrorEventWithName(AnalyticsConstants.eventApiPasswordResetConfirmFail, screenName: weakSelf?.screenName, error: error)
                    weakSelf?.showOkDialog(title: .Error, message: .GenericError, analyticDialogName: AnalyticsConstants.paramNameErrorDialog, screenName: weakSelf?.screenName ?? nil)
            }
            return
        }
            
        signup(signupCustomer: signupCustomer)
        
    }

    private func signup(signupCustomer: SignupCustomer) {
        
        guard let email = signupCustomer.email else { return }
        guard let password = volvoPwdConfirmTextField.textField.text else { return }

        if let customer = UserManager.sharedInstance.getCustomer() {
            
            if UserManager.sharedInstance.isLoggedIn() {
                self.showLoading(loading: false)
                self.loadMainScreen()
                return
            } else if !customer.passwordResetRequired {
                loginUser(email: email, password: password)
                return
            }
        }
        weak var weakSelf = self

        guard let phoneNumber = signupCustomer.phoneNumber else { return }
        guard let verificationCode = signupCustomer.verificationCode else { return }
        
        CustomerAPI().confirmSignup(email: email, phoneNumber: phoneNumber, password: password, verificationCode: verificationCode).onSuccess { result in
            if let customer = result?.data?.result {
                VLAnalytics.logEventWithName(AnalyticsConstants.eventApiConfirmSignupSuccess, screenName: weakSelf?.screenName ?? nil)
                if let realm = weakSelf?.realm {
                    try? realm.write {
                        realm.deleteAll()
                        realm.add(customer)
                    }
                }
                UserManager.sharedInstance.setCustomer(customer: customer)
                weakSelf?.loginUser(email: email, password: password)
            }
            }.onFailure { error in
                VLAnalytics.logErrorEventWithName(AnalyticsConstants.eventApiConfirmSignupFail, screenName: weakSelf?.screenName ?? nil, error: error)
                weakSelf?.onSignupError(error: error)
        }
    }
    
    func loginUser(email: String, password: String) {
        weak var weakSelf = self

        CustomerAPI().login(email: email, password: password).onSuccess { result in
            if let tokenObject = result?.data?.result, let customerId = tokenObject.customerId {
                VLAnalytics.logEventWithName(AnalyticsConstants.eventApiLoginSuccess, screenName: weakSelf?.screenName)
                // Get Customer object with ID
                UserManager.sharedInstance.loginSuccess(token: tokenObject.token, customerId: String(customerId))
                weakSelf?.showLoading(loading: false)
                weakSelf?.goToNext()
            } else {
                VLAnalytics.logErrorEventWithName(AnalyticsConstants.eventApiLoginFail, screenName: weakSelf?.screenName ?? nil)
                weakSelf?.onSignupError()
            }
            }.onFailure { error in
                VLAnalytics.logErrorEventWithName(AnalyticsConstants.eventApiLoginFail, screenName: weakSelf?.screenName ?? nil, error: error)
                weakSelf?.onSignupError(error: error)
        }
    }
    
    func loginUser(phoneNumber: String, password: String) {
        weak var weakSelf = self

        CustomerAPI().login(phoneNumber: phoneNumber, password: password).onSuccess { result in
            if let tokenObject = result?.data?.result, let customerId = tokenObject.customerId {
                VLAnalytics.logEventWithName(AnalyticsConstants.eventApiLoginSuccess, screenName: weakSelf?.screenName)
                // Get Customer object with ID
                UserManager.sharedInstance.loginSuccess(token: tokenObject.token, customerId: String(customerId))
                weakSelf?.showLoading(loading: false)
                weakSelf?.goToNext()
            } else {
                VLAnalytics.logErrorEventWithName(AnalyticsConstants.eventApiLoginFail, screenName: weakSelf?.screenName ?? nil)
                weakSelf?.onSignupError()
            }
            }.onFailure { error in
                VLAnalytics.logErrorEventWithName(AnalyticsConstants.eventApiLoginFail, screenName: weakSelf?.screenName ?? nil, error: error)
                weakSelf?.onSignupError(error: error)
        }
    }
    
    override func goToNext() {
        loadMainScreen()
    }
    
    
}
