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
    
    public static let tosURL = "https://terms-luxebyvolvo.luxe.com/"
    public static let privacyURL = "https://privacy-luxebyvolvo.luxe.com/"
    
    let emailTextField = VLVerticalTextField(title: .EmailAddress, placeholder: .EmailPlaceholder)
    
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
    
    let tosCheckbox = VLCheckbox(title: nil)
    
    let tosLabel: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.font = .volvoSansProRegular(size: 12)
        textView.textColor = .luxeDarkGray()
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    var tosNSRange: NSRange?
    var privacyNSRange: NSRange?

    var signupInProgress = false
    var realm : Realm?
    var deeplinkEventConsumed = false
    
    init() {
        super.init(screen: .signupPhone)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realm = try? Realm()
        
        let phoneNumberTF: PhoneNumberTextField = phoneNumberTextField.textField as! PhoneNumberTextField
        phoneNumberTF.maxDigits = 10

        // support autofill
        self.phoneNumberTextField.textField.textContentType = .telephoneNumber
        self.emailTextField.textField.textContentType = .emailAddress

        phoneNumberTextField.accessibilityIdentifier = "phoneNumberTextField"
        emailTextField.accessibilityIdentifier = "emailTextField"
        tosCheckbox.accessibilityIdentifier = "tosCheckbox"
        
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

        let tosString = String(format: NSLocalizedString(.AgreeToTosAndPrivacyFormat), String.TermsAndConditions, String.PrivacyPolicy)
        let attributedString = NSMutableAttributedString(string: tosString)
        let tosRange = attributedString.string.range(of: String.TermsAndConditions)
        let privacyRange = attributedString.string.range(of: String.PrivacyPolicy)
        
        tosNSRange = NSRange(tosRange!, in: tosString)
        privacyNSRange = NSRange(privacyRange!, in: tosString)

        let linkAttributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: UIColor.luxeCobaltBlue(), NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        
        attributedString.addAttributes(linkAttributes, range: tosNSRange!)
        attributedString.addAttributes(linkAttributes, range: privacyNSRange!)

        tosLabel.attributedText = attributedString
        tosLabel.isUserInteractionEnabled = true
        let tosTap = UITapGestureRecognizer(target: self, action: #selector(self.tosTap(_:)))
        tosLabel.addGestureRecognizer(tosTap)
        
        tosCheckbox.delegate = self
        
        canGoNext(nextEnabled: false)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.emailTextField.textField.becomeFirstResponder()

        if DeeplinkManager.sharedInstance.isPrefillSignup() && !deeplinkEventConsumed {
            if let email = DeeplinkManager.sharedInstance.getDeeplinkObject()?.email {
                emailTextField.textField.text = email
            }
            if let phoneNumber = DeeplinkManager.sharedInstance.getDeeplinkObject()?.phoneNumber {
                phoneNumberTextField.textField.text = phoneNumber
            }
            
            deeplinkEventConsumed = true
            
            if checkTextFieldsValidity() {
                if DeeplinkManager.sharedInstance.prefillSignupContinue {
                    self.onRightClicked()
                    DeeplinkManager.sharedInstance.prefillSignupContinue = false
                }
            }
        }
    }
    
    override func setupViews() {
        
        super.setupViews()
        
        scrollView.addSubview(phoneNumberLabel)
        scrollView.addSubview(phoneNumberConfirmLabel)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(phoneNumberTextField)
        scrollView.addSubview(tosCheckbox)
        scrollView.addSubview(tosLabel)
        
        phoneNumberLabel.snp.makeConstraints { (make) -> Void in
            make.equalsToTop(view: scrollView.contentView, offset: BaseViewController.defaultTopYOffset)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        emailTextField.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(BaseViewController.defaultTopYOffset)
            make.height.equalTo(VLVerticalTextField.verticalHeight)
        }
        
        phoneNumberTextField.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(emailTextField.snp.bottom)
            make.height.equalTo(VLVerticalTextField.verticalHeight)
        }
        
        phoneNumberConfirmLabel.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(phoneNumberLabel)
            make.top.equalTo(phoneNumberTextField.snp.bottom).offset(-34)
        }
        
        tosCheckbox.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(phoneNumberConfirmLabel.snp.bottom).offset(20)
            make.left.equalTo(phoneNumberConfirmLabel).offset(-10)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
        
        tosLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(tosCheckbox)
            make.left.equalTo(tosCheckbox.snp.right)
            make.right.equalToSuperview().offset(-10)
        }
    }
  
    
    //MARK: Validation methods
    
    @objc func tosTap(_ tapGesture: UITapGestureRecognizer) {
        if tapGesture.didTapAttributedTextInLabel(tosLabel, inRange: tosNSRange!) {
            Analytics.trackClick(button: .termsOfService)
            self.pushViewController(VLWebViewController(urlAddress: FTUESignupEmailPhoneViewController.tosURL, title: .TermsAndConditions, showReloadButton: true), animated: true)
        } else if tapGesture.didTapAttributedTextInLabel(tosLabel, inRange: privacyNSRange!) {
            Analytics.trackClick(button: .privacyPolicy)
            self.pushViewController(VLWebViewController(urlAddress: FTUESignupEmailPhoneViewController.privacyURL, title: .PrivacyPolicy, showReloadButton: true), animated: true)
        }
    }
    
    func isEmailValid(email: String?) -> Bool {
        guard let email = email else { return false }
        if email.isEmpty { return false }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
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
    
    private func onSignupError(error: LuxeAPIError? = nil) {
        self.showLoading(loading: false)
        
        if let code = error?.code {
            
            if code == Errors.ErrorCode.E5001.rawValue {
                self.showOkDialog(title: .Error, message: .PhoneNumberAlreadyExist, dialog: .error, screen: self.screen)
            } else if code == Errors.ErrorCode.E4011.rawValue {
                self.showOkDialog(title: .Error, message: .AccountAlreadyExist, completion: {
                    self.loadLandingPage()
                }, dialog: .error, screen: self.screen)
            } else if code == Errors.ErrorCode.E4046.rawValue {
                self.showOkDialog(title: .Error, message: .PhoneNumberInvalid, dialog: .error, screen: self.screen)
            } else  {
                self.showOkDialog(title: .Error, message: .GenericError, dialog: .error, screen: self.screen)
            }
        } else {
            self.showOkDialog(title: .Error, message: .GenericError, dialog: .error, screen: self.screen)
        }
    }
    
    func showLoading(loading: Bool) {
        if signupInProgress == loading {
            return
        }
        signupInProgress = loading
        if loading {
            self.showProgressHUD()
        } else {
            self.hideProgressHUD()
        }
    }

    // MARK:- Validation
    
    override func checkTextFieldsValidity() -> Bool {
        let enabled = isEmailValid(email: emailTextField.textField.text) && isPhoneNumberValid(phoneNumber: phoneNumberTextField.textField.text)
        canGoNext(nextEnabled: enabled)
        return enabled
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        textField.trimText()
        _ = checkTextFieldsValidity()
    }

    // MARK: UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            phoneNumberTextField.textField.becomeFirstResponder()
        } else {
            if checkTextFieldsValidity() {
                self.onRightClicked()
            } else {
                // show error
            }
        }
        return false
    }
    
    //MARK: FTUEStartViewController
    
    override func onRightClicked() {
        super.onRightClicked()
        
        if !tosCheckbox.checked {
            
            phoneNumberTextField.textField.resignFirstResponder()
            emailTextField.textField.resignFirstResponder()
            
            tosCheckbox.shake()
            tosLabel.shake()
            
            tosLabel.textColor = .luxeRed()
            return
        } else {
            tosLabel.textColor = .luxeDarkGray()
        }
        
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
        
        if let createdCustomer = UserManager.sharedInstance.getCustomer() {
            
            if UserManager.sharedInstance.isLoggedIn() {
                self.showLoading(loading: false)
                self.loadMainScreen()
                return
            } else {
                if createdCustomer.phoneNumberVerified {
                    self.showOkDialog(title: .Error, message: .AccountAlreadyExist, completion: {
                        self.loadLandingPage()
                    }, dialog: .error, screen: self.screen)
                    return
                }
            }
        }
        
        var language = "EN" // default to EN
        if let localeLang = Locale.current.languageCode {
            language = localeLang.uppercased()
        }
        
        guard let email = signupCustomer.email else { return }
        guard let phoneNumber = signupCustomer.phoneNumber else { return }
        guard let firstName = signupCustomer.firstName else { return }
        guard let lastName = signupCustomer.lastName else { return }

        CustomerAPI.signup(email: email, phoneNumber: phoneNumber, firstName: firstName, lastName: lastName, languageCode: language) { customer, error in
            if let customer = customer {

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
                self.onSignupError(error: error)
            }
        }
    }
    
    override func goToNext() {
        self.showLoading(loading: false)
        self.pushViewController(FTUEPhoneVerificationViewController(), animated: true)
    }
}

extension FTUESignupEmailPhoneViewController : VLCheckboxDelegate {
    
    func onCheckChanged(checked: Bool) {
        Analytics.trackClick(button: .termsOfServiceCheckbox, screen: screen, selected: checked)
        _ = checkTextFieldsValidity()
        
    }
}
