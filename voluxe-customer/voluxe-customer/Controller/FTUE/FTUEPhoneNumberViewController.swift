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
        textView.text = .MobilePhoneNumberConfirm
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    let ftuePhoneType: FTUEPhoneType
    
    init(type: FTUEPhoneType) {
        self.ftuePhoneType = type
        super.init(screen: type == .update ? AnalyticsEnums.Name.Screen.phoneUpdate : AnalyticsEnums.Name.Screen.passwordReset)
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
        
        let phoneNumberTF: PhoneNumberTextField = phoneNumberTextField.textField as! PhoneNumberTextField
        phoneNumberTF.maxDigits = 10
        
        if ftuePhoneType == .resetPassword {
            self.phoneNumberLabel.text = .MobilePhoneNumberResetPassword
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
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(sizeThatFits)
        }
        
        phoneNumberTextField.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(BaseViewController.defaultTopYOffset)
            make.height.equalTo(VLVerticalTextField.verticalHeight)
        }
        
        phoneNumberConfirmLabel.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(phoneNumberLabel)
            make.top.equalTo(phoneNumberTextField.snp.bottom)
        }
    }
    
    func isPhoneNumberValid(phoneNumber: String?) -> Bool {
        guard let phoneNumber = phoneNumber else { return false }
        guard let textField = phoneNumberTextField.textField as? PhoneNumberTextField else { return false }
        
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
        textField.trimText()
        _ = checkTextFieldsValidity()
    }
    
    //MARK: FTUEStartViewController
    
    override func onRightClicked() {
        super.onRightClicked()
        guard let validPhoneNumber = validPhoneNumber else { return }
        
        UserManager.sharedInstance.signupCustomer.phoneNumber = phoneNumberKit.format(validPhoneNumber, toType: .e164)
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
                    if let code = error.code, code == Errors.ErrorCode.E4001.rawValue {
                        self.showOkDialog(title: .Error, message: .PhoneNumberNotInFile, dialog: .error, screen: self.screen)
                    } else {
                        self.showOkDialog(title: .Error, message: .GenericError, dialog: .error, screen: self.screen)
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
                    if let code = error.code, code == Errors.ErrorCode.E4011.rawValue {
                        self.showOkDialog(title: .Error, message: .UpdatePhoneNumberAlreadyExist, dialog: .error, screen: self.screen)
                    } else {
                        self.showOkDialog(title: .Error, message: .GenericError, dialog: .error, screen: self.screen)
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
                    self.showOkDialog(title: .Error, message: .GenericError, dialog: .error, screen: self.screen)
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
