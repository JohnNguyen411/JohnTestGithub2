//
//  PhoneVerificationViewController.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 1/14/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class PhoneVerificationViewController: StepViewController, UITextFieldDelegate {
    
    let codeLength = 4
    let codeTextField = VLVerticalTextField(title: "", placeholder: "0000", kern: 4.0)
    
    private let confirmationLabel = Label.dark(with: Unlocalized.letsVerifyPhoneNumber)
    
    // MARK: Lifecycle
    
    override init(step: Step?) {
        super.init(step: step)
    }
    
    convenience init() {
        self.init(step: nil)
        self.navigationItem.title = Unlocalized.confirmPhoneNumber
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        Analytics.trackView(screen: .phoneVerification)
        
        // support autofill
        // note that autofill for an OTC requires the code to be
        // either first or last in the message text
        if #available(iOS 12.0, *) {
            self.codeTextField.textField.textContentType = .oneTimeCode
        }
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Volvo.background.light
        
        self.codeTextField.textField.delegate = self
        self.codeTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        self.codeTextField.textField.keyboardType = .numberPad
        self.codeTextField.setRightButtonText(rightButtonText: "RESEND CODE", actionBlock: {  [weak self] in
            self?.resendCode()
        })
        
        self.confirmationLabel.textAlignment = .left
        
        _ = checkTextFieldsValidity()
        
        let scrollView = Layout.scrollView(in: self)
        let contentView = Layout.verticalContentView(in: scrollView)
        let gridView = contentView.addGridLayoutView(with: GridLayout.volvoAgent())
        
        
        gridView.add(subview: self.confirmationLabel, from: 1, to: 6)
        self.confirmationLabel.pinToSuperviewTop(spacing: 40)
        
        gridView.add(subview: self.codeTextField, from: 1, to: 6)
        self.codeTextField.pinTopToBottomOf(view: self.confirmationLabel, spacing: 40)
        self.codeTextField.heightAnchor.constraint(equalToConstant: CGFloat(VLVerticalTextField.verticalHeight)).isActive = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // hide back button if needed
        self.hideBackButton(AppController.shared.isVerifyingPhoneNumber)
        
        self.codeTextField.textField.becomeFirstResponder()
        
        super.viewDidAppear(animated)

    }
    
    // MARK: Navigation
    
    override func hasNextButton() -> Bool {
        return true
    }
    
    override func hasBackButton() -> Bool {
        return true
    }

    
    // MARK: Actions
    
    @objc override func nextButtonTouchUpInside() {
        self.textFieldDidChange(self.codeTextField.textField)
        Analytics.trackClick(navigation: .next, screen: .phoneVerification)
    }
    
    @objc override func backButtonTouchUpInside() {
        Analytics.trackClick(navigation: .back, screen: .phoneVerification)

        if !self.popStep() {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func resendCode() {
        guard let driver = DriverManager.shared.driver else { return }

        AppController.shared.lookBusy()
        DriverAPI.requestPhoneNumberVerification(for: driver, completion: { error in
            AppController.shared.lookNotBusy()

            if let error = error {
                AppController.shared.alertGeneric(for: error, retry: false, completion: nil)
            }
        })
    }
    
    private func verifyCode(code: String) {
        guard let driver = DriverManager.shared.driver else { return }
        
        AppController.shared.lookBusy()
        
        DriverAPI.verifyPhoneNumber(with: code, for: driver, completion: { [weak self] error in
            
            if let error = error {
                AppController.shared.lookNotBusy()
                AppController.shared.alertGeneric(for: error, retry: false, completion: nil)
            } else {
                self?.refreshDriver()
            }
        })
    }
    
    private func refreshDriver() {
        DriverManager.shared.me(completion: { [weak self] driver, error in
            AppController.shared.lookNotBusy()
            if let driver = driver {
                
                AppController.shared.isVerifyingPhoneNumber = false
                
                guard let weakSelf = self else { return }
                
                if !weakSelf.pushNextStep() {
                    if driver.photoUrl == nil || driver.photoUrl?.count == 0 {
                        AppController.shared.mainController(push: SelfieViewController(),
                                                            asRootViewController: true,
                                                            prefersProfileButton: false)
                    } else {
                        let controller = MyScheduleViewController()
                        AppController.shared.mainController(push: controller,
                                                            asRootViewController: true,
                                                            prefersProfileButton: true)
                    }
                }
                
            } else {
                AppController.shared.alertGeneric(for: error, retry: false, completion: nil)
            }
        })
    }
    
    // MARK: Validity checks

    private func isCodeValid(code: String?) -> Bool {
        guard let code = code else { return false }
        guard code.count == codeLength else { return false }
        guard code.isDigitsOnly() == false else { return false }
        return true
    }
    
    private func checkTextFieldsValidity() -> Bool {
        let enabled = isCodeValid(code: codeTextField.textField.text)
        nextButtonEnabled(enabled: enabled)
        return enabled
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let enabled  = checkTextFieldsValidity()
        if let code = textField.text, code.count == codeLength, enabled {
            self.verifyCode(code: code)
        }
    }
    
    //MARK: UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= codeLength
    }
}
