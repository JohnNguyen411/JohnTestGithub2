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
        textView.text = .createPassword
        textView.font = .volvoSansProRegular(size: 16)
        textView.volvoProLineSpacing()
        textView.textColor = .luxeDarkGray()
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    let passwordConditionLabel: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.font = .volvoSansProMedium(size: 11)
        textView.textColor = .luxeGray()
        textView.text = .viewSigninPasswordDescription
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()

    // This textfield is required to allow AutoFill password generation
    // to work.  There must be a visible (not hidden) .username tagged
    // field for a password to be generated, but that does not fit with
    // the visual style and API order that we use.  Instead, the workaround
    // is to make the field not editable, but then move it offscreen.
    let usernameTextField: UITextField = {
        let textfield = UITextField()
        textfield.borderStyle = .none
        textfield.isEnabled = false
        textfield.text = UserManager.sharedInstance.currentCustomerEmail
        textfield.textColor = UIColor.luxeWhite()
        if #available(iOS 11.0, *) {
            textfield.textContentType = .username
        }
        return textfield
    }()

    let volvoPwdTextField = VLVerticalTextField(title: .viewEditTextTitlePasswordNew, placeholder: "••••••••", kern: 2.0)
    let volvoPwdConfirmTextField = VLVerticalTextField(title: .viewEditTextTitlePasswordConfirm, placeholder: "••••••••", kern: 2.0)
    
    var signupInProgress = false
    var realm : Realm?
    
    init() {
        super.init(screen: .signupPassword)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // support autofill
        if #available(iOS 12.0, *) {
            self.volvoPwdTextField.textField.textContentType = .newPassword
            self.volvoPwdConfirmTextField.textField.textContentType = .newPassword
        }

        volvoPwdTextField.accessibilityIdentifier = "volvoPwdTextField"
        volvoPwdConfirmTextField.accessibilityIdentifier = "volvoPwdConfirmTextField"
                
        volvoPwdTextField.showPasswordToggleIcon = true
        volvoPwdConfirmTextField.showPasswordToggleIcon = true
        
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

        // note that the user has to tap into the field for Password
        // AutoFill to work, forcing it to first responder won't work.
        canGoNext(nextEnabled: false)
        
        if UserManager.sharedInstance.isLoggedIn() {
            passwordLabel.text = .updatePassword
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.volvoPwdTextField.textField.becomeFirstResponder()
    }
    
    override func setupViews() {
        
        super.setupViews()

        scrollView.addSubview(passwordLabel)
        scrollView.addSubview(passwordConditionLabel)
        scrollView.addSubview(volvoPwdTextField)
        scrollView.addSubview(volvoPwdConfirmTextField)
        
        passwordLabel.snp.makeConstraints { (make) -> Void in
            make.equalsToTop(view: self.view, offset: BaseViewController.defaultTopYOffset)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        passwordConditionLabel.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(passwordLabel)
            make.top.equalTo(passwordLabel.snp.bottom).offset(-2)
            make.height.equalTo(30)
        }
        
        volvoPwdTextField.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(passwordConditionLabel)
            make.top.equalTo(passwordConditionLabel.snp.bottom).offset(BaseViewController.defaultTopYOffset)
            make.height.equalTo(VLVerticalTextField.verticalHeight)
        }
        
        volvoPwdConfirmTextField.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(volvoPwdTextField)
            make.top.equalTo(volvoPwdTextField.snp.bottom)
            make.height.equalTo(VLVerticalTextField.verticalHeight)
        }

        // moving the username field offscreen seems to satisfy Password AutoFill's
        // requirement of a visible username field for the Generate Strong Password modal
        self.view.insertSubview(self.usernameTextField, belowSubview: self.volvoPwdTextField)
        self.usernameTextField.snp.makeConstraints {
            make in
            make.trailing.equalTo(self.scrollView.snp.leading)
        }
    }
    
    //MARK: Validation methods
    
    override func checkTextFieldsValidity() -> Bool {
        let enabled = (volvoPwdTextField.textField.text?.isMinimumPasswordLength() ?? false) &&
                      (volvoPwdConfirmTextField.textField.text?.isMinimumPasswordLength() ?? false)
        canGoNext(nextEnabled: enabled)
        return enabled
    }
    
    private func onSignupError(error: Errors? = nil) {
        self.showLoading(loading: false)
        
        if let apiError = error?.apiError {
            if apiError.getCode() == .E5001 {
                self.showOkDialog(title: .error, message: .errorAccountAlreadyExists, completion: {
                    self.loadLandingPage()
                }, dialog: .error, screen: self.screen)
            } else if apiError.getCode() == .E4012 {
                self.showOkDialog(title: .error, message: .errorInvalidVerificationCode, completion: {
                    self.navigationController?.popViewController(animated: true)
                }, dialog: .error, screen: self.screen)
            }
        } else {
            self.showOkDialog(title: .error, message: .errorUnknown, dialog: .error, screen: self.screen)
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
        if let text = volvoPwdConfirmTextField.bottomRightLabel.text, text.count > 0 {
            volvoPwdConfirmTextField.resetErrorState()
            volvoPwdConfirmTextField.bottomRightLabel.text = ""
        }
    }
    
    //MARK: FTUEStartViewController
    
    private func inlineError(error: String) {
        volvoPwdConfirmTextField.applyErrorState()
        volvoPwdConfirmTextField.setBottomRightText(bottomRightText: error.uppercased(), actionBlock: nil)
    }
    
    override func onRightClicked() {
        super.onRightClicked()
        let signupCustomer = UserManager.sharedInstance.signupCustomer
        
        if signupInProgress {
            return
        }
        
        if !String.areSimilar(stringOne: volvoPwdTextField.textField.text, stringTwo: volvoPwdConfirmTextField.textField.text) {
            //DOES NOT MATCH
            inlineError(error: .errorPasswordNotMatch)
            return
        } else if let password = volvoPwdConfirmTextField.textField.text, !password.containsLetter() {
            inlineError(error: .viewSignupPasswordRequireLetter)
            return
        } else if let password = volvoPwdConfirmTextField.textField.text, !password.containsNumber() {
            inlineError(error: .viewSignupPasswordRequireNumber)
            return
        } else if let password = volvoPwdConfirmTextField.textField.text, password.hasIllegalPasswordCharacters() {
            inlineError(error: .errorInvalidCharacter)
            volvoPwdConfirmTextField.setBottomRightActionBlock { [weak self] in
                self?.showOkDialog(title: .error, message: .errorInvalidPasswordUnauthorizedCharacters, dialog: .error, screen: self?.screen)
            }
            return
        }
        
        showLoading(loading: true)
        
        weak var weakSelf = self
        
        // if user is logged in, it's a password update
        if let code = UserManager.sharedInstance.signupCustomer.verificationCode,
            let password = volvoPwdConfirmTextField.textField.text, let customerId = UserManager.sharedInstance.customerId(),
            signupCustomer.email == nil, UserManager.sharedInstance.isLoggedIn() {
            CustomerAPI().passwordChange(customerId: customerId, code: code, password: password).onSuccess { result in
                weakSelf?.showLoading(loading: false)
                weakSelf?.navigationController?.popToRootViewController(animated: true)
                }.onFailure { error in
                    weakSelf?.showOkDialog(title: .error, message: .errorUnknown, dialog: .error, screen: weakSelf?.screen)
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
                // password successfully updated, login the user
                weakSelf?.loginUser(phoneNumber: phoneNumber, password: password)
                
                }.onFailure { error in
                    weakSelf?.showLoading(loading: false)
                    weakSelf?.showOkDialog(title: .error, message: .errorUnknown, dialog: .error, screen: weakSelf?.screen)
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
                if DeeplinkManager.sharedInstance.isPrefillSignup() {
                    Analytics.trackView(app: .deeplinkSuccess, screen: weakSelf?.screen)
                }
                if let realm = weakSelf?.realm {
                    try? realm.write {
                        realm.deleteAll()
                        realm.add(customer)
                    }
                }
                UserManager.sharedInstance.setCustomer(customer: customer)
                weakSelf?.loginUser(email: email, password: password)
                Analytics.trackView(screen: .signupComplete)
            }
            }.onFailure { error in
                weakSelf?.onSignupError(error: error)
        }
    }
    
    func loginUser(email: String, password: String) {
        weak var weakSelf = self

        CustomerAPI().login(email: email, password: password).onSuccess { result in
            if let tokenObject = result?.data?.result, let customerId = tokenObject.customerId {
                // Get Customer object with ID
                UserManager.sharedInstance.loginSuccess(token: tokenObject.token, customerId: String(customerId))
                weakSelf?.showLoading(loading: false)
                weakSelf?.goToNext()
            } else {
                weakSelf?.onSignupError()
            }
            }.onFailure { error in
                weakSelf?.onSignupError(error: error)
        }
    }
    
    func loginUser(phoneNumber: String, password: String) {
        weak var weakSelf = self

        CustomerAPI().login(phoneNumber: phoneNumber, password: password).onSuccess { result in
            if let tokenObject = result?.data?.result, let customerId = tokenObject.customerId {
                // Get Customer object with ID
                UserManager.sharedInstance.loginSuccess(token: tokenObject.token, customerId: String(customerId))
                weakSelf?.showLoading(loading: false)
                weakSelf?.goToNext()
            } else {
                weakSelf?.onSignupError()
            }
            }.onFailure { error in
                weakSelf?.onSignupError(error: error)
        }
    }
    
    override func goToNext() {
        loadMainScreen()
    }
}
