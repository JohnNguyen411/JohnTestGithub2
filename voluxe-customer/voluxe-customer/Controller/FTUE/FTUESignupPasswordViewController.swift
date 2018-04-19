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
    let accessToken: String?
    
    init() {
        accessToken = UserManager.sharedInstance.getAccessToken()
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
        
        if accessToken != nil {
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
        guard let password = password else {
            return false
        }
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
    
    private func onSignupError(error: ResponseError? = nil) {
        //todo show error message
        self.showLoading(loading: false)
        
        if error?.code == "E5001" {
            self.showOkDialog(title: .Error, message: .AccountAlreadyExist, completion: {
                self.loadLandingPage()
            })
        } else if error?.code == "E4012" {
            self.showOkDialog(title: .Error, message: .InvalidVerificationCode, completion: {
                self.navigationController?.popViewController(animated: true)
            })
        } else {
            self.showOkDialog(title: .Error, message: .GenericError)
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
                self.nextButtonTap()
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
    
    override func nextButtonTap() {
        let signupCustomer = UserManager.sharedInstance.signupCustomer
        
        if signupInProgress {
            return
        }
        
        if let password = volvoPwdConfirmTextField.textField.text, containsUnauthorizedChars(password: password) {
            self.showOkDialog(title: .Error, message: .PasswordUnauthorizedChars)
            return
        }
        
        showLoading(loading: true)
        
        if UIApplication.isRunningTest {
            loginUser(email: "johan@luxe.com", password: "Ch@ngeth1s")
            return
        }
        
        // if accessToken, it's a password update
        if let code = UserManager.sharedInstance.signupCustomer.verificationCode,
            let password = volvoPwdConfirmTextField.textField.text, let customerId = UserManager.sharedInstance.getCustomerId(),
            signupCustomer.email == nil, accessToken != nil {
            CustomerAPI().passwordChange(customerId: customerId, code: code, password: password).onSuccess { result in
                if let _ = result?.error {
                    // error
                    self.showOkDialog(title: .Error, message: .GenericError)
                } else {
                    self.navigationController?.popToRootViewController(animated: true)
                }
                }.onFailure { error in
                    self.showOkDialog(title: .Error, message: .GenericError)
                }
                    
            return
        }
        
        // if no access token, no temp email, no cust id, and a phone number, it's a reset password
        // if accessToken, it's a password update
        if let code = UserManager.sharedInstance.signupCustomer.verificationCode,
            let password = volvoPwdConfirmTextField.textField.text,
            let phoneNumber = UserManager.sharedInstance.signupCustomer.phoneNumber,
            UserManager.sharedInstance.getCustomerId() == nil, signupCustomer.email == nil, accessToken == nil {
            CustomerAPI().passwordResetConfirm(phoneNumber: phoneNumber, code: code, password: password).onSuccess { result in
                if let _ = result?.error {
                    // error
                    self.showOkDialog(title: .Error, message: .GenericError)
                } else {
                    // password successfully updated, proceed to login
                    self.navigationController?.popToRootViewController(animated: true)
                    self.showOkDialog(title: .Success, message: .PasswordResetLogin, completion: {
                        self.navigationController?.pushViewController(FTUELoginViewController(), animated: true)
                    });
                }
                }.onFailure { error in
                    self.showOkDialog(title: .Error, message: .GenericError)
            }
            return
        }
            
        signup(signupCustomer: signupCustomer)
        
    }
    
    private func signup(signupCustomer: SignupCustomer) {
        if let customer = UserManager.sharedInstance.getCustomer() {
            
            if UserManager.sharedInstance.getAccessToken() != nil {
                self.showLoading(loading: false)
                self.loadMainScreen()
                return
            } else if !customer.passwordResetRequired {
                loginUser(email: signupCustomer.email!, password: volvoPwdConfirmTextField.textField.text!)
                return
            }
        }
        
        CustomerAPI().confirmSignup(email: signupCustomer.email!, phoneNumber: signupCustomer.phoneNumber!, password: volvoPwdConfirmTextField.textField.text!, verificationCode: signupCustomer.verificationCode!).onSuccess { result in
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
                self.onSignupError(error: result?.error)
            }
            }.onFailure { error in
                self.onSignupError()
        }
    }
    
    func loginUser(email: String, password: String) {
        CustomerAPI().login(email: email, password: password).onSuccess { result in
            if let tokenObject = result?.data?.result, let customerId = tokenObject.customerId {
                // Get Customer object with ID
                UserManager.sharedInstance.loginSuccess(token: tokenObject.token, customerId: String(customerId))
                self.showLoading(loading: false)
                self.goToNext()
            } else {
                self.onSignupError()
            }
            }.onFailure { error in
                self.onSignupError()
        }
    }
    
    override func goToNext() {
        loadMainScreen()
    }
    
    
}
