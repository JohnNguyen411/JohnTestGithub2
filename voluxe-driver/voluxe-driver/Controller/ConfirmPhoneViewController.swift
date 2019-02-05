//
//  ConfirmPhoneViewController.swift
//  voluxe-driver
//
//  Created by Christoph on 12/20/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit
import FlagPhoneNumber
import libPhoneNumber_iOS

class ConfirmPhoneViewController: StepViewController, FPNTextFieldDelegate {

    // MARK: Layout
    private let phoneNumberTextField = VLVerticalTextField(title: Unlocalized.phoneNumber, placeholder: "(555) 555-5555", isPhoneNumber: true)
    var validPhoneNumber: NBPhoneNumber?
    let phoneUtil = NBPhoneNumberUtil.sharedInstance()
    var countryCode: String?

    private let verifyLabel = Label.dark(with: Unlocalized.letsVerifyPhoneNumber)
    private let cancelButton = UIButton.Volvo.secondary(title: Unlocalized.cancel)
    private let nextButton = UIButton.Volvo.primary(title: Unlocalized.next)

    // MARK: Lifecycle
    
    override init(step: Step? = nil) {
        super.init(step: step)
        if let textField = phoneNumberTextField.textField as? FPNTextField {
            textField.flagPhoneNumberDelegate = self
            countryCode = textField.getDefaultCountryCode()
        }
        
        self.addActions()
    }

    convenience init(title: String) {
        self.init(step: nil)
        self.navigationItem.title = title.capitalized
        
        if let textField = phoneNumberTextField.textField as? FPNTextField {
            textField.flagPhoneNumberDelegate = self
            countryCode = textField.getDefaultCountryCode()
        }
        
        self.addActions()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {

        // support autofill
        // note that autofill for an OTC requires the code to be
        // either first or last in the message text
        if #available(iOS 12.0, *) {
            self.phoneNumberTextField.textField.textContentType = .telephoneNumber
        }
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Volvo.background.light
        
        self.phoneNumberTextField.textField.keyboardType = .phonePad
        self.phoneNumberTextField.textField.textContentType = .telephoneNumber
        self.phoneNumberTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        verifyLabel.textAlignment = .left
        
        _ = checkTextFieldsValidity()

        let scrollView = Layout.scrollView(in: self)
        let contentView = Layout.verticalContentView(in: scrollView)
        let gridView = contentView.addGridLayoutView(with: GridLayout.volvoAgent())

        
        gridView.add(subview: self.verifyLabel, from: 1, to: 6)
        self.verifyLabel.pinToSuperviewTop(spacing: 40)

        gridView.add(subview: self.phoneNumberTextField, from: 1, to: 6)
        self.phoneNumberTextField.pinTopToBottomOf(view: self.verifyLabel, spacing: 40)
        self.phoneNumberTextField.heightAnchor.constraint(equalToConstant: CGFloat(VLVerticalTextField.verticalHeight)).isActive = true
        
        gridView.add(subview: self.cancelButton, from: 1, to: 2)
        self.cancelButton.pinTopToBottomOf(view: self.phoneNumberTextField, spacing: 20)

        gridView.add(subview: self.nextButton, from: 3, to: 4)
        self.nextButton.pinTopToBottomOf(view: self.phoneNumberTextField, spacing: 20)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.phoneNumberTextField.textField.becomeFirstResponder()
    }

    // MARK: Actions

    private func addActions() {
        self.nextButton.addTarget(self, action: #selector(nextButtonTouchUpInside), for: .touchUpInside)
        self.cancelButton.addTarget(self, action: #selector(cancelButtonTouchUpInside), for: .touchUpInside)
    }

    @objc func nextButtonTouchUpInside() {
        // if entered phone is same as driver.workPhone, then request verification code, otherwise update phone number
        guard let validPhoneNumber = validPhoneNumber else { return }
        guard let driver = DriverManager.shared.driver else { return }
        
        do {
            if let phoneUtil = self.phoneUtil {
                let fullPhoneNumber = try phoneUtil.format(validPhoneNumber, numberFormat: .E164)
                if fullPhoneNumber == driver.workPhoneNumber {
                    // request verification code
                    self.requestVerificationCode(driver: driver)
                } else {
                    // update phone number
                    self.updateWorkPhoneNumber(phoneNumber: fullPhoneNumber, driver: driver)
                }
            }
        } catch {}
        
    }

    @objc func cancelButtonTouchUpInside() {
        if !self.popStep() {
            AppController.shared.logout()
        }
    }
    
    private func pushVerificationCodeViewController() {
        if !self.pushNextStep() {
            AppController.shared.mainController(push: PhoneVerificationViewController())
        }
    }
    
    //MARK: API Calls
    
    private func requestVerificationCode(driver: Driver) {
        AppController.shared.lookBusy()
        DriverAPI.requestPhoneNumberVerification(for: driver, completion: { [weak self]
            error in
            AppController.shared.lookNotBusy()
            if error == nil {
                // go to next
                self?.pushVerificationCodeViewController()

            } else {
                AppController.shared.alert(message: Unlocalized.genericError)
            }
        })
    }
    
    private func updateWorkPhoneNumber(phoneNumber: String, driver: Driver) {
        AppController.shared.lookBusy()
        DriverAPI.update(phoneNumber: phoneNumber, for: driver) { [weak self]
            error in
            if error == nil {
                self?.refreshDriver()
            } else {
                AppController.shared.lookNotBusy()
                AppController.shared.alert(message: Unlocalized.genericError)
            }
        }
    }
    
    private func refreshDriver() {
        DriverManager.shared.me(completion: { [weak self] driver, error in
            AppController.shared.lookNotBusy()
            if let _ = driver {
                // go to next
                self?.pushVerificationCodeViewController()
            } else {
                AppController.shared.alert(message: Unlocalized.genericError)
            }
        })
    }

    
    // MARK: Validity Check

    private func isPhoneNumberValid() -> Bool {
        if validPhoneNumber != nil {
            return true
        }
        return false
    }
    
    private func checkTextFieldsValidity() -> Bool {
        let enabled = isPhoneNumberValid()
        nextButton.isEnabled = enabled
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
    
    // MARK: Step State
    override func saveStepState() {
        if let step = self.step as? PhoneNumberStep {
            step.phoneNumber = self.phoneNumberTextField.text
        }
    }
    
    override func restoreStepState() {
        if let step = self.step as? PhoneNumberStep, let phoneNumber = step.phoneNumber {
            self.phoneNumberTextField.textField.text = phoneNumber
            // trigger phone number validation
            if let fpnTextField = phoneNumberTextField.textField as? FPNTextField {
                fpnDidValidatePhoneNumber(textField: fpnTextField, isValid: false)
            }
        }
    }

}

class PhoneNumberStep: Step {
    var phoneNumber: String?
    
    init() {
        super.init(title: Unlocalized.confirmPhoneNumber, controllerName: ConfirmPhoneViewController.className)
    }
}
