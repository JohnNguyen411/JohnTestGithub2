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
    let codeTextField = VLVerticalTextField(title: "", placeholder: .PhoneNumberVerif_Placeholder, kern: 4.0)
    
    let updatePhoneNumberButton: VLButton
    
    var ftuePhoneType: FTUEPhoneType = .update
    
    let phoneNumberLabel: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.text = .PhoneNumberVerifLabel
        textView.font = .volvoSansLight(size: 18)
        textView.textColor = .luxeDarkGray()
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    init() {
        let analyticsName = FTUEStartViewController.flowType == .signup ? AnalyticsConstants.paramNameSignupPhoneVerificationView : AnalyticsConstants.paramNamePhoneVerificationView
        updatePhoneNumberButton = VLButton(type: .blueSecondary, title: String.ChangePhoneNumber.uppercased(), kern: UILabel.uppercasedKern(), actionBlock: nil, eventName: AnalyticsConstants.eventClickUpdatePhoneNumber, screenName: analyticsName)
        
        super.init(screenName: analyticsName)
    }
    
    convenience init(type: FTUEPhoneType) {
        self.init()
        self.ftuePhoneType = type
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var isLoading = false
    
    override func viewDidLoad() {
        
        codeTextField.accessibilityIdentifier = "codeTextField"
        codeTextField.textField.delegate = self
        super.viewDidLoad()
        codeTextField.textField.keyboardType = .numberPad
        codeTextField.setRightButtonText(rightButtonText: (.ResendCode as String).uppercased(), actionBlock: {
            self.resendCode()
        })
        codeTextField.rightLabel.addCharacterSpacing(kernValue: UILabel.uppercasedKern())
        
        updatePhoneNumberButton.setActionBlock {
            self.updatePhoneNumber()
        }
        
        codeTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        codeTextField.textField.becomeFirstResponder()
        _ = checkTextFieldsValidity()
        
        if FTUEStartViewController.flowType == .signup {
            canGoBack(backEnabled: false)
        }
        
        if ftuePhoneType == .resetPassword {
            updatePhoneNumberButton.isHidden = true
        }
    }
    
    override func rightButtonTitle() -> String {
        if FTUEStartViewController.flowType == .login {
            return .Done
        } else {
            return super.rightButtonTitle()
        }
    }
    
    override func setupViews() {
        
        self.view.addSubview(codeTextField)
        self.view.addSubview(phoneNumberLabel)
        self.view.addSubview(updatePhoneNumberButton)
        
        updatePhoneNumberButton.contentHorizontalAlignment = .left
        
        phoneNumberLabel.snp.makeConstraints { (make) -> Void in
            make.top.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        codeTextField.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(20)
            make.height.equalTo(40)
        }
        
        updatePhoneNumberButton.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(codeTextField.snp.bottom).offset(15)
            make.height.equalTo(20)
        }
        
    }
    
    @objc func updatePhoneNumber() {
        self.navigationController?.pushViewController(FTUEPhoneNumberViewController(type: .update), animated: true)
    }
    
    @objc func resendCode() {
        
        if isLoading {
            return
        }
        
        if ftuePhoneType == .resetPassword {
            guard let phoneNumber = UserManager.sharedInstance.signupCustomer.phoneNumber else {
                return
            }
            
            isLoading = true
            
            self.showProgressHUD()

            CustomerAPI().passwordReset(phoneNumber: phoneNumber).onSuccess { result in
                self.hideProgressHUD()
                if result?.error != nil {
                    self.showOkDialog(title: .Error, message: .GenericError)
                }
                self.isLoading = false
                self.codeTextField.textField.text = ""
                }.onFailure { error in
                    self.hideProgressHUD()
                    self.showOkDialog(title: .Error, message: .GenericError)
                    self.isLoading = false
            }
            return
        }
        
        var customerId = UserManager.sharedInstance.getCustomerId()
        if customerId == nil {
            customerId = UserManager.sharedInstance.tempCustomerId
        }
        
        if customerId == nil {
            return
        }
        
        
        if let customer = UserManager.sharedInstance.getCustomer(), customer.phoneNumberVerified {
            self.showProgressHUD()

            CustomerAPI().requestPasswordChange(customerId: customer.id).onSuccess { result in
                self.hideProgressHUD()
                if result?.error != nil {
                    self.showOkDialog(title: .Error, message: .GenericError)
                }
                self.isLoading = false
                }.onFailure { error in
                    self.hideProgressHUD()
                    self.showOkDialog(title: .Error, message: .GenericError)
                    self.isLoading = false
            }
            return
        }
        
        isLoading = true
        
        self.showProgressHUD()

        CustomerAPI().requestPhoneVerificationCode(customerId: customerId!).onSuccess { result in
            self.hideProgressHUD()
            if result?.error != nil {
                self.showOkDialog(title: .Error, message: .GenericError)
            }
            self.isLoading = false
        }.onFailure { error in
            self.hideProgressHUD()
            self.showOkDialog(title: .Error, message: .GenericError)
            self.isLoading = false
        }
        
    }
    
    func isCodeValid(code: String?) -> Bool {
        // check code validity
        if let code = code {
            return code.count == codeLength
        }
        return false
    }
    
    override func checkTextFieldsValidity() -> Bool {
        let enabled = isCodeValid(code: codeTextField.textField.text)
        canGoNext(nextEnabled: enabled)
        return enabled
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        _ = checkTextFieldsValidity()
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        Logger.print("textFieldDidBeginEditing")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        Logger.print("textField shouldChangeCharactersIn")
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= codeLength // Bool
    }
    
    //MARK: FTUEStartViewController
    
    override func nextButtonTap() {
        UserManager.sharedInstance.signupCustomer.verificationCode = codeTextField.textField.text
        goToNext()
    }
    
    
    override func goToNext() {
        if FTUEStartViewController.flowType == .signup || ftuePhoneType == .resetPassword {
            self.navigationController?.pushViewController(FTUESignupPasswordViewController(), animated: true)
        } else {
            
            var customerId = UserManager.sharedInstance.getCustomerId()
            if customerId == nil {
                customerId = UserManager.sharedInstance.tempCustomerId
            }
            
            if isLoading || customerId == nil {
                return
            }
            
            isLoading = true
            
            self.showProgressHUD()

            // verify phone number
            CustomerAPI().verifyPhoneNumber(customerId: customerId!, verificationCode: codeTextField.textField.text!).onSuccess { result in
                self.hideProgressHUD()
                if result?.error != nil {
                    self.showOkDialog(title: .Error, message: .GenericError)
                } else {
                    self.loadMainScreen()
                }
                
                self.isLoading = false
                }.onFailure { error in
                    self.hideProgressHUD()
                    self.showOkDialog(title: .Error, message: .GenericError)
                    self.isLoading = false
            }
        }
    }
    

}
