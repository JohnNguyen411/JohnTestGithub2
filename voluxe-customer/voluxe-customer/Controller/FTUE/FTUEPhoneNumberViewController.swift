//
//  FTUEPhoneNumberViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 10/31/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
import PhoneNumberKit
import MBProgressHUD

class FTUEPhoneNumberViewController: FTUEChildViewController {
    
    let phoneNumberTextField = VLVerticalTextField(title: .MobilePhoneNumber, placeholder: .MobilePhoneNumber_Placeholder, isPhoneNumber: true)
    let phoneNumberKit = PhoneNumberKit()
    var validPhoneNumber: PhoneNumber?

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
    
    let ftuePhoneType: FTUEPhoneType
    
    init(type: FTUEPhoneType) {
        self.ftuePhoneType = type
        super.init(screenName: type == .update ? AnalyticsConstants.ParamNameUpdatePasswordView : AnalyticsConstants.ParamNameResetPasswordView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneNumberTextField.accessibilityIdentifier = "phoneNumberTextField"
        phoneNumberTextField.textField.keyboardType = .phonePad
        phoneNumberTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        let phoneNumberTF: PhoneNumberTextField = phoneNumberTextField.textField as! PhoneNumberTextField
        phoneNumberTF.maxDigits = 10
        
        if ftuePhoneType == .resetPassword {
            self.phoneNumberLabel.text = .MobilePhoneNumberResetPassword
        }
        
        phoneNumberTextField.textField.becomeFirstResponder()
        _ = checkTextFieldsValidity()
        
    }
    
    override func setupViews() {
        
        self.view.addSubview(phoneNumberTextField)
        self.view.addSubview(phoneNumberLabel)
        self.view.addSubview(phoneNumberConfirmLabel)
                
        let sizeThatFits = phoneNumberLabel.sizeThatFits(CGSize(width: view.frame.width-40, height: CGFloat(MAXFLOAT)))

        phoneNumberLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(sizeThatFits)
        }
        
        phoneNumberTextField.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(15)
            make.height.equalTo(VLVerticalTextField.height)
        }
        
        phoneNumberConfirmLabel.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(phoneNumberLabel)
            make.top.equalTo(phoneNumberTextField.snp.bottom)
            make.height.equalTo(20)
        }
    }
    
    func isPhoneNumberValid(phoneNumber: String?) -> Bool {
        guard let phoneNumber = phoneNumber else {
            return false
        }
        
        guard let textField = phoneNumberTextField.textField as? PhoneNumberTextField else {
            return false
        }
        
        do {
            validPhoneNumber = try phoneNumberKit.parse(phoneNumber, withRegion: textField.currentRegion, ignoreType: true)
            return true
        } catch {
            return false
        }
 
    }
    
    override func checkTextFieldsValidity() -> Bool {
        let enabled = isPhoneNumberValid(phoneNumber: phoneNumberTextField.textField.text)
        canGoNext(nextEnabled: enabled)
        return enabled
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        _ = checkTextFieldsValidity()
    }
    
    //MARK: FTUEStartViewController
    
    override func nextButtonTap() {
        guard let validPhoneNumber = validPhoneNumber else {
            return
        }
        
        UserManager.sharedInstance.signupCustomer.phoneNumber = phoneNumberKit.format(validPhoneNumber, toType: .e164)
        //update customer
        updatePhoneNumber()
        
    }
    
    private func updatePhoneNumber() {
        
        guard let phoneNumber = UserManager.sharedInstance.signupCustomer.phoneNumber else {
            return
        }
        
        if isLoading {
            return
        }
        
        if ftuePhoneType == .resetPassword {
            isLoading = true
            
            showProgressHUD()

            CustomerAPI().passwordReset(phoneNumber: phoneNumber).onSuccess { result in
                self.hideProgressHUD()
                if result?.error != nil {
                    self.showOkDialog(title: .Error, message: .GenericError)
                }
                self.isLoading = false
                self.goToNext()
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
        
        isLoading = true
        
        showProgressHUD()

        CustomerAPI().updatePhoneNumber(customerId: customerId!, phoneNumber: phoneNumber).onSuccess { result in
            self.hideProgressHUD()
            if result?.error != nil {
                self.showOkDialog(title: .Error, message: .GenericError)
            }
            self.isLoading = false
            self.goToNext()
            }.onFailure { error in
                self.hideProgressHUD()
                self.showOkDialog(title: .Error, message: .GenericError)
                self.isLoading = false
        }
    }
    
    override func goToNext() {
        if ftuePhoneType == .resetPassword {
            // enter need password
            self.navigationController?.pushViewController(FTUEPhoneVerificationViewController(type: ftuePhoneType), animated: true)
        } else {
            appDelegate?.startApp()
        }
    }
}

public enum FTUEPhoneType {
    case update
    case resetPassword
}
