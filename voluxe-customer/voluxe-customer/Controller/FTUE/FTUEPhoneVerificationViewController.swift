//
//  FTUEPhoneVerificationViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 10/31/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

class FTUEPhoneVerificationViewController: FTUEChildViewController, UITextFieldDelegate {
    
    let codeLength = 4
    let codeTextField = VLVerticalTextField(title: "", placeholder: .viewPhoneVerificationCodeHint, kern: 4.0)
    
    let updatePhoneNumberButton: VLButton
    
    var ftuePhoneType: FTUEPhoneType = .update
    
    let phoneNumberLabel: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.text = .viewPhoneVerificationLabel
        textView.font = .volvoSansProRegular(size: 16)
        textView.volvoProLineSpacing()
        textView.textColor = .luxeDarkGray()
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    init() {
        let screen = FTUEStartViewController.flowType == .signup ? AnalyticsEnums.Name.Screen.signupPhoneVerification : AnalyticsEnums.Name.Screen.phoneVerification
        updatePhoneNumberButton = VLButton(type: .blueSecondary, title: String.changePhoneNumber.uppercased(), kern: UILabel.uppercasedKern(), event: .updatePhone, screen: screen)
        
        super.init(screen: screen)
    }
    
    convenience init(type: FTUEPhoneType) {
        self.init()
        self.ftuePhoneType = type
        if FTUEStartViewController.flowType == .login {
            self.navigationItem.rightBarButtonItem?.title = .localized(.done)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var isLoading = false
    
    override func viewDidLoad() {

        // support autofill
        // note that autofill for an OTC requires the code to be
        // either first or last in the message text
        if #available(iOS 12.0, *) {
            self.codeTextField.textField.textContentType = .oneTimeCode
        }

        codeTextField.accessibilityIdentifier = "codeTextField"
        codeTextField.textField.delegate = self
        super.viewDidLoad()
        codeTextField.textField.keyboardType = .numberPad
        codeTextField.setRightButtonText(rightButtonText: (.resendCode as String).uppercased(), actionBlock: {  [weak self] in
            self?.resendCode()
        })
        codeTextField.rightLabel.addUppercasedCharacterSpacing()
        
        updatePhoneNumberButton.setActionBlock { [weak self] in
            self?.updatePhoneNumber()
        }
        
        codeTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        _ = checkTextFieldsValidity()
        
        if FTUEStartViewController.flowType == .signup {
            canGoBack(backEnabled: false)
        }
        
        if ftuePhoneType == .resetPassword {
            updatePhoneNumberButton.isHidden = true
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.codeTextField.textField.becomeFirstResponder()
    }

    override func setupViews() {
        super.setupViews()
        
        scrollView.addSubview(codeTextField)
        scrollView.addSubview(phoneNumberLabel)
        scrollView.addSubview(updatePhoneNumberButton)
        
        updatePhoneNumberButton.contentHorizontalAlignment = .leftOrLeading()
        
        phoneNumberLabel.snp.makeConstraints { (make) -> Void in
            make.equalsToTop(view: self.view, offset: BaseViewController.defaultTopYOffset)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        codeTextField.snp.makeConstraints { (make) -> Void in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(BaseViewController.defaultTopYOffset)
            make.height.equalTo(40)
        }
        
        updatePhoneNumberButton.snp.makeConstraints { (make) -> Void in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(codeTextField.snp.bottom).offset(15)
            make.height.equalTo(20)
        }
        
    }
    
    @objc func updatePhoneNumber() {
        self.codeTextField.textField.resignFirstResponder()
        self.pushViewController(FTUEPhoneNumberViewController(type: .update), animated: true)
    }
    
    @objc func resendCode() {
        
        if isLoading { return }
        
        if ftuePhoneType == .resetPassword {
            guard let phoneNumber = UserManager.sharedInstance.signupCustomer.phoneNumber else { return }
            
            isLoading = true
            
            self.showProgressHUD()

            // initiate password reset with phone number (request code)
            CustomerAPI.passwordReset(phoneNumber: phoneNumber) { error in
                
                if error == nil {
                    self.hideProgressHUD()
                    self.showOkDialog(title: .localized(.error), message: .localized(.errorUnknown), dialog: .error, screen: self.screen)
                    self.isLoading = false
                } else {
                    self.hideProgressHUD()
                    self.isLoading = false
                    self.codeTextField.textField.text = ""
                }
            }
            return
        }
        
        var customerId = UserManager.sharedInstance.customerId()
        if customerId == nil {
            customerId = UserManager.sharedInstance.tempCustomerId
        }
        
        if customerId == nil {
            return
        }
        
        
        if let customer = UserManager.sharedInstance.getCustomer(), customer.phoneNumberVerified {
            self.showProgressHUD()
            
            // initiate password reset with phone number (request code)
            CustomerAPI.requestPasswordChange(customerId: customer.id) { error in
                if error == nil {
                    self.hideProgressHUD()
                    self.isLoading = false
                } else {
                    self.hideProgressHUD()
                    self.showOkDialog(title: .localized(.error), message: .localized(.errorUnknown), dialog: .error, screen: self.screen)
                    self.isLoading = false
                }
            }
            return
        }
        
        isLoading = true
        
        self.showProgressHUD()
        let signupCustomer = UserManager.sharedInstance.signupCustomer
        
        if UserManager.sharedInstance.isLoggedIn() {
            
            // resend phone verification code
            CustomerAPI.requestPhoneVerificationCode(customerId: customerId!) { error in
                
                if error == nil {
                    self.hideProgressHUD()
                    self.isLoading = false
                } else {
                    self.hideProgressHUD()
                    self.showOkDialog(title: .localized(.error), message: .localized(.errorUnknown), dialog: .error, screen: self.screen)
                    self.isLoading = false
                }
            }
        } else if let email = signupCustomer.email, let phoneNumber = signupCustomer.phoneNumber, let firstName = signupCustomer.firstName , let lastName = signupCustomer.lastName {
            
            var language = "EN" // default to EN
            if let localeLang = Locale.current.languageCode {
                language = localeLang.uppercased()
            }
            
            CustomerAPI.signup(email: email, phoneNumber: phoneNumber, firstName: firstName, lastName: lastName, languageCode: language) { customer, error in
                self.hideProgressHUD()

                if error != nil {
                    self.showOkDialog(title: .localized(.error), message: .localized(.errorUnknown), dialog: .error, screen: self.screen)
                }
            }
        }
    }
    
    func isCodeValid(code: String?) -> Bool {
        guard let code = code else { return false }
        guard code.count == codeLength else { return false }
        guard code.isDigitsOnly() == false else { return false }
        return true
    }
    
    override func checkTextFieldsValidity() -> Bool {
        let enabled = isCodeValid(code: codeTextField.textField.text)
        canGoNext(nextEnabled: enabled)
        return enabled
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let enabled  = checkTextFieldsValidity()
        if let text = textField.text, text.count == codeLength, enabled {
            UserManager.sharedInstance.signupCustomer.verificationCode = codeTextField.textField.text
            goToNext()
        }
    }
    
    //MARK: UITextFieldDelegate

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= codeLength // Bool
    }
    
    //MARK: FTUEStartViewController
    
    override func onRightClicked() {
        super.onRightClicked()
        UserManager.sharedInstance.signupCustomer.verificationCode = codeTextField.textField.text
        self.goToNext()
    }

    override func goToNext() {
        if FTUEStartViewController.flowType == .signup || ftuePhoneType == .resetPassword {
            self.codeTextField.textField.resignFirstResponder()
            self.pushViewController(FTUESignupPasswordViewController(), animated: true)
        } else {
            
            var tempCustomerId = UserManager.sharedInstance.customerId()
            if tempCustomerId == nil {
                tempCustomerId = UserManager.sharedInstance.tempCustomerId
            }
            
            if isLoading {
                return
            }
            
            guard let customerId = tempCustomerId else { return }
            guard let verificationCode = codeTextField.textField.text else { return }
            
            isLoading = true
            
            self.showProgressHUD()

            // verify phone number
            CustomerAPI.verifyPhoneNumber(customerId: customerId, verificationCode: verificationCode) { error in
                
                if error == nil {
                    self.codeTextField.textField.resignFirstResponder()
                    
                    self.hideProgressHUD()
                    self.loadMainScreen()
                    self.isLoading = false
                } else {
                    
                    self.hideProgressHUD()
                    if let code = error?.code, code == .E4012 {
                        self.showOkDialog(title: .localized(.error), message: .localized(.errorInvalidVerificationCode), dialog: .error, screen: self.screen)
                    } else {
                        self.showOkDialog(title: .localized(.error), message: .localized(.errorUnknown), dialog: .error, screen: self.screen)
                    }
                    self.isLoading = false
                }
            }
        }
    }
    

}
