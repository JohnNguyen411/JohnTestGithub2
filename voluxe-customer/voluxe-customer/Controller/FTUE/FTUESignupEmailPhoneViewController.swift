//
//  FTUESignupEmailPhoneViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 2/27/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
import PhoneNumberKit
import RealmSwift
import MBProgressHUD

class FTUESignupEmailPhoneViewController: FTUEChildViewController, UITextFieldDelegate {
    
    let emailTextField = VLVerticalTextField(title: .EmailAddress, placeholder: .EmailPlaceholder)
    
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
    
    var signupInProgress = false
    var realm : Realm?
    
    init() {
        super.init(screenName: AnalyticsConstants.paramNameSignupEmailPhoneView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realm = try? Realm()
        
        let phoneNumberTF: PhoneNumberTextField = phoneNumberTextField.textField as! PhoneNumberTextField
        phoneNumberTF.maxDigits = 10
        
        phoneNumberTextField.accessibilityIdentifier = "phoneNumberTextField"
        emailTextField.accessibilityIdentifier = "emailTextField"
        
        emailTextField.textField.autocorrectionType = .no
        phoneNumberTextField.textField.autocorrectionType = .no
        
        phoneNumberTextField.textField.keyboardType = .phonePad
        emailTextField.textField.keyboardType = .emailAddress
        emailTextField.textField.autocapitalizationType = .none
        
        emailTextField.textField.returnKeyType = .next
        phoneNumberTextField.textField.returnKeyType = .done
        
        emailTextField.textField.delegate = self
        phoneNumberTextField.textField.delegate = self

        phoneNumberTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        
        emailTextField.textField.becomeFirstResponder()
        canGoNext(nextEnabled: false)
                
    }
    
    override func setupViews() {
        
        self.view.addSubview(phoneNumberLabel)
        self.view.addSubview(phoneNumberConfirmLabel)
        self.view.addSubview(emailTextField)
        self.view.addSubview(phoneNumberTextField)
        
        phoneNumberLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        emailTextField.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(20)
            make.height.equalTo(VLVerticalTextField.height)
        }
        
        phoneNumberTextField.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(emailTextField.snp.bottom).offset(15)
            make.height.equalTo(VLVerticalTextField.height)
        }
        
        phoneNumberConfirmLabel.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(phoneNumberLabel)
            make.top.equalTo(phoneNumberTextField.snp.bottom).offset(-4)
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
    
    private func onSignupError(error: ResponseError? = nil) {
        //todo show error message
        self.showLoading(loading: false)
        
        
        if error?.code == "E5001" {
            self.showOkDialog(title: .Error, message: .PhoneNumberAlreadyExist)
        } else if error?.code == "E4011" {
            self.showOkDialog(title: .Error, message: .AccountAlreadyExist, completion: {
                self.loadLandingPage()
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
    
    override func checkTextFieldsValidity() -> Bool {
        let enabled = isEmailValid(email: emailTextField.textField.text) && isPhoneNumberValid(phoneNumber: phoneNumberTextField.textField.text)
        canGoNext(nextEnabled: enabled)
        return enabled
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        _ = checkTextFieldsValidity()
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            phoneNumberTextField.textField.becomeFirstResponder()
        } else {
            if checkTextFieldsValidity() {
                nextButtonTap()
            } else {
                // show error
            }
        }
        return false
    }
    
    //MARK: FTUEStartViewController
    
    override func nextButtonTap() {
        guard let validPhoneNumber = validPhoneNumber else {
            return
        }
        
        UserManager.sharedInstance.signupCustomer.email = emailTextField.textField.text
        UserManager.sharedInstance.signupCustomer.phoneNumber = phoneNumberKit.format(validPhoneNumber, toType: .e164)
        // signup
        
        let signupCustomer = UserManager.sharedInstance.signupCustomer
        
        if signupInProgress {
            return
        }
        
        showLoading(loading: true)
        
        if UserManager.sharedInstance.getCustomer() != nil {
            
            if UserManager.sharedInstance.getAccessToken() != nil {
                self.showLoading(loading: false)
                self.loadMainScreen()
            } else {
                onSignupError(error: ResponseError(JSON: ["code" : "E4011"]))
            }
            return
        }
        
        if UIApplication.isRunningTest {
            let customer = Customer.mockCustomer()
            if let realm = self.realm {
                try? realm.write {
                    realm.deleteAll()
                    realm.add(customer)
                }
            }
            UserManager.sharedInstance.setCustomer(customer: customer)
            UserManager.sharedInstance.tempCustomerId = customer.id
            self.goToNext()
            return
        }
        
        CustomerAPI().signup(email: signupCustomer.email!, phoneNumber: signupCustomer.phoneNumber!, firstName: signupCustomer.firstName!, lastName: signupCustomer.lastName!, languageCode: Locale.preferredLanguages[0].uppercased()).onSuccess { result in
            if let customer = result?.data?.result {
                if let realm = self.realm {
                    try? realm.write {
                        realm.deleteAll()
                        realm.add(customer)
                    }
                }
                UserManager.sharedInstance.setCustomer(customer: customer)
                UserManager.sharedInstance.tempCustomerId = customer.id
                self.goToNext()
            } else {
                self.onSignupError(error: result?.error)
            }
            }.onFailure { error in
                self.onSignupError()
        }
    }
    
    override func goToNext() {
        self.hideProgressHUD()
        self.navigationController?.pushViewController(FTUEPhoneVerificationViewController(), animated: true)
    }
}
