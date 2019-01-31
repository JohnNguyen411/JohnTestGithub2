//
//  FTUEPhoneNumberViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 10/31/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
import FlagPhoneNumber
import MBProgressHUD
import libPhoneNumber_iOS

class FTUEPhoneNumberViewController: FTUEChildViewController, FPNTextFieldDelegate {
    
    let phoneNumberTextField = VLVerticalTextField(title: .viewEditTextTitlePhoneNumber, placeholder: .viewEditTextInfoHintPhoneNumber, isPhoneNumber: true)
    var validPhoneNumber: NBPhoneNumber?
    let phoneUtil = NBPhoneNumberUtil.sharedInstance()
    var countryCode: String?
    
    let phoneNumberLabel: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.text = .viewSignupContactLabel
        textView.font = .volvoSansProRegular(size: 16)
        textView.volvoProLineSpacing()
        textView.textColor = .luxeDarkGray()
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    let phoneNumberConfirmLabel: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.font = .volvoSansProRegular(size: 12)
        textView.textColor = .luxeDarkGray()
        textView.text = .viewEditTextPhoneDescription
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    let ftuePhoneType: FTUEPhoneType
    
    init(type: FTUEPhoneType) {
        self.ftuePhoneType = type
        super.init(screen: type == .update ? AnalyticsEnums.Name.Screen.phoneUpdate : AnalyticsEnums.Name.Screen.passwordReset)
        
        if let textField = phoneNumberTextField.textField as? FPNTextField {
            textField.flagPhoneNumberDelegate = self
            countryCode = textField.getDefaultCountryCode()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneNumberTextField.accessibilityIdentifier = "phoneNumberTextField"
        phoneNumberTextField.textField.keyboardType = .phonePad
        phoneNumberTextField.textField.textContentType = .telephoneNumber
        phoneNumberTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        if ftuePhoneType == .resetPassword {
            self.phoneNumberLabel.text = .viewSigninPhoneLabel
        }
        
        _ = checkTextFieldsValidity()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.phoneNumberTextField.textField.becomeFirstResponder()
    }
    
    override func setupViews() {
        super.setupViews()
        
        scrollView.addSubview(phoneNumberTextField)
        scrollView.addSubview(phoneNumberLabel)
        scrollView.addSubview(phoneNumberConfirmLabel)
        
        let sizeThatFits = phoneNumberLabel.sizeThatFits(CGSize(width: view.frame.width-40, height: CGFloat(MAXFLOAT)))
        
        phoneNumberLabel.snp.makeConstraints { (make) -> Void in
            make.equalsToTop(view: self.view, offset: BaseViewController.defaultTopYOffset)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(sizeThatFits)
        }
        
        phoneNumberTextField.snp.makeConstraints { (make) -> Void in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(BaseViewController.defaultTopYOffset)
            make.height.equalTo(VLVerticalTextField.verticalHeight)
        }
        
        phoneNumberConfirmLabel.snp.makeConstraints { (make) -> Void in
            make.leading.trailing.equalTo(phoneNumberLabel)
            make.top.equalTo(phoneNumberTextField.snp.bottom)
        }
    }
    
    func isPhoneNumberValid() -> Bool {
        if validPhoneNumber != nil {
            return true
        }
        return false
    }
    
    override func checkTextFieldsValidity() -> Bool {
        let enabled = isPhoneNumberValid()
        canGoNext(nextEnabled: enabled)
        return enabled
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        textField.trimText()
        _ = checkTextFieldsValidity()
    }
    
    //MARK: FPNTextFieldDelegate
    
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        countryCode = code
    }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        if let countryCode = countryCode {
            if isValid {
                validPhoneNumber = textField.getValidNumber(phoneNumber: textField.getRawPhoneNumber() ?? "", countryCode: countryCode)
                return
            }
            let phoneNumber = textField.getInputPhoneNumber()
            textField.setFlagForPhoneNumber(phoneNumber: phoneNumber)
            
            validPhoneNumber = textField.getValidNumber(phoneNumber: phoneNumber ?? "", countryCode: countryCode)
            if let nbPhoneNumber = validPhoneNumber {
                textField.set(phoneNumber: nbPhoneNumber.nationalNumber.stringValue)
            }
        } else {
            validPhoneNumber = nil
        }
    }
    
    //MARK: FTUEStartViewController
    
    override func onRightClicked() {
        super.onRightClicked()
        guard let validPhoneNumber = validPhoneNumber else { return }
        
        do {
            if let phoneUtil = self.phoneUtil {
                UserManager.sharedInstance.signupCustomer.phoneNumber = try phoneUtil.format(validPhoneNumber, numberFormat: .E164)
            }
        } catch {}
        //update customer
        updatePhoneNumber()
        
    }
    
    private func updatePhoneNumber() {
        
        guard let phoneNumber = UserManager.sharedInstance.signupCustomer.phoneNumber else { return }
        
        if isLoading { return }
        
        if ftuePhoneType == .resetPassword {
            isLoading = true
            
            showProgressHUD()
            
            CustomerAPI.passwordReset(phoneNumber: phoneNumber) { error in
                
                if let error = error {
                    self.hideProgressHUD()
                    if let code = error.code, code == .E4001 {
                        self.showOkDialog(title: .localized(.error), message: .localized(.errorPhoneNumberNotInFile), dialog: .error, screen: self.screen)
                    } else {
                        self.showOkDialog(title: .localized(.error), message: .localized(.errorUnknown), dialog: .error, screen: self.screen)
                    }
                    self.isLoading = false
                } else {
                    self.hideProgressHUD()
                    self.isLoading = false
                    self.goToNext()
                }
            }
            return
        }
        
        var tempCustomerId = UserManager.sharedInstance.customerId()
        if tempCustomerId == nil {
            tempCustomerId = UserManager.sharedInstance.tempCustomerId
        }
        
        guard let customerId = tempCustomerId else { return }
        
        isLoading = true
        
        showProgressHUD()
        let signupCustomer = UserManager.sharedInstance.signupCustomer
        
        if UserManager.sharedInstance.isLoggedIn() {
            
            CustomerAPI.updatePhoneNumber(customerId: customerId, phoneNumber: phoneNumber) { error in
                
                if let error = error {
                    self.hideProgressHUD()
                    if let code = error.code, code == .E4011 {
                        self.showOkDialog(title: .localized(.error), message: .localized(.errorUpdatePhoneNumberAlreadyExist), dialog: .error, screen: self.screen)
                    } else {
                        self.showOkDialog(title: .localized(.error), message: .localized(.errorUnknown), dialog: .error, screen: self.screen)
                    }
                    self.isLoading = false
                } else {
                    self.hideProgressHUD()
                    self.isLoading = false
                    self.goToNext()
                }
                
                
            }
        } else if let email = signupCustomer.email, let phoneNumber = signupCustomer.phoneNumber, let firstName = signupCustomer.firstName , let lastName = signupCustomer.lastName {
            
            var language = "EN" // default to EN
            if let localeLang = Locale.current.languageCode {
                language = localeLang.uppercased()
            }
            
            CustomerAPI.signup(email: email, phoneNumber: phoneNumber, firstName: firstName, lastName: lastName, languageCode: language) { customer, error in
                self.hideProgressHUD()
                if customer != nil {
                    self.goToNext()
                } else {
                    self.showOkDialog(title: .localized(.error), message: .localized(.errorUnknown), dialog: .error, screen: self.screen)
                }
            }
        }
    }
    
    
    override func goToNext() {
        if ftuePhoneType == .resetPassword {
            // enter need password
            self.pushViewController(FTUEPhoneVerificationViewController(type: ftuePhoneType), animated: true)
        } else {
            if UserManager.sharedInstance.isLoggedIn() {
                AppController.sharedInstance.startApp()
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

public enum FTUEPhoneType {
    case update
    case resetPassword
}
