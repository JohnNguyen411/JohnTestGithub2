//
//  ForgotPasswordViewController.swift
//  voluxe-driver
//
//  Created by Christoph on 12/22/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class ForgotPasswordViewController: StepViewController, UITextFieldDelegate {

    // MARK: Layout
    private let currentPasswordTextField = VLVerticalTextField(title: Unlocalized.currentPassword, placeholder: "••••••••")
    private let newPasswordTextField = VLVerticalTextField(title: Unlocalized.newPassword, placeholder: "••••••••")
    private let passwordConfirmTextField = VLVerticalTextField(title: Unlocalized.confirmNewPassword, placeholder: "••••••••")

    private let cancelButton = UIButton.Volvo.secondary(title: Unlocalized.cancel)
    private let nextButton = UIButton.Volvo.primary(title: Unlocalized.update)

    // MARK: Lifecycle

    override init(step: Step? = nil) {
        super.init(step: step)
        self.addActions()
    }
    
    convenience init(title: String) {
        self.init(step: nil)
        self.navigationItem.title = title.capitalized
        self.addActions()
    }
    
    convenience init() {
        self.init(title: Unlocalized.createPassword)
        self.addActions()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.currentPasswordTextField.textField.becomeFirstResponder()
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Volvo.background.light
        
        currentPasswordTextField.textField.autocorrectionType = .no
        currentPasswordTextField.textField.isSecureTextEntry = true
        currentPasswordTextField.textField.returnKeyType = .next
        currentPasswordTextField.textField.delegate = self
        currentPasswordTextField.showPasswordToggleIcon = true

        newPasswordTextField.textField.autocorrectionType = .no
        newPasswordTextField.textField.isSecureTextEntry = true
        newPasswordTextField.textField.returnKeyType = .next
        newPasswordTextField.textField.delegate = self
        newPasswordTextField.showPasswordToggleIcon = true
        
        passwordConfirmTextField.textField.autocorrectionType = .no
        passwordConfirmTextField.textField.isSecureTextEntry = true
        passwordConfirmTextField.textField.returnKeyType = .done
        passwordConfirmTextField.textField.delegate = self
        passwordConfirmTextField.showPasswordToggleIcon = true
        
        currentPasswordTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        newPasswordTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordConfirmTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        _ = checkTextFieldsValidity()

        let scrollView = Layout.scrollView(in: self)
        let contentView = Layout.verticalContentView(in: scrollView)
        let gridView = contentView.addGridLayoutView(with: GridLayout.volvoAgent())
        
        gridView.add(subview: self.currentPasswordTextField, from: 1, to: 6)
        self.currentPasswordTextField.pinToSuperviewTop(spacing: 40)
        self.currentPasswordTextField.heightAnchor.constraint(equalToConstant: CGFloat(VLVerticalTextField.height)).isActive = true
        
        gridView.add(subview: self.newPasswordTextField, from: 1, to: 6)
        self.newPasswordTextField.pinTopToBottomOf(view: self.currentPasswordTextField, spacing: 20)
        self.newPasswordTextField.heightAnchor.constraint(equalToConstant: CGFloat(VLVerticalTextField.height)).isActive = true
        
        gridView.add(subview: self.passwordConfirmTextField, from: 1, to: 6)
        self.passwordConfirmTextField.pinTopToBottomOf(view: self.newPasswordTextField, spacing: 20)
        self.passwordConfirmTextField.heightAnchor.constraint(equalToConstant: CGFloat(VLVerticalTextField.height)).isActive = true

        self.cancelButton.isUserInteractionEnabled = true
        gridView.add(subview: self.cancelButton, from: 1, to: 2)
        self.cancelButton.pinTopToBottomOf(view: passwordConfirmTextField, spacing: 40)

        self.nextButton.isUserInteractionEnabled = true
        gridView.add(subview: self.nextButton, from: 3, to: 4)
        self.nextButton.pinTopToBottomOf(view: passwordConfirmTextField, spacing: 40)
    }

    // MARK: Actions

    private func addActions() {
        self.nextButton.addTarget(self, action: #selector(nextButtonTouchUpInside), for: .touchUpInside)
        self.cancelButton.addTarget(self, action: #selector(cancelButtonTouchUpInside), for: .touchUpInside)
    }

    @objc func nextButtonTouchUpInside() {
        
        guard let driver = DriverManager.shared.driver else { return }
        
        if !String.areSimilar(stringOne: newPasswordTextField.text, stringTwo: passwordConfirmTextField.text) {
            //DOES NOT MATCH
            inlineError(error: "DoesNotMatch")
            return
        } else if !passwordConfirmTextField.text.containsLetter() {
            inlineError(error: "RequiresALetter")
            return
        } else if !passwordConfirmTextField.text.containsNumber() {
            inlineError(error: "RequiresANumber")
            return
        } else if passwordConfirmTextField.text.hasIllegalPasswordCharacters() {
            inlineError(error: "InvalidCharacter")
            passwordConfirmTextField.setBottomRightActionBlock {
                AppController.shared.alert(title: Unlocalized.error, message: "PasswordUnauthorizedChars")
            }
            return
        }
        
        AppController.shared.lookBusy()
        DriverAPI.update(tempPassword: currentPasswordTextField.text, newPassword: passwordConfirmTextField.text, for: driver, completion: { [weak self] error in
            AppController.shared.lookNotBusy()
            if let error = error {
                // error
                self?.onLoginError(error: error)
            } else {
                DriverManager.shared.me(completion: { driver, error in
                    if let error = error {
                        // error
                        self?.onLoginError(error: error)
                    }
                    
                    guard let weakSelf = self else { return }
                    
                    if !weakSelf.pushNextStep() {
                        AppController.shared.mainController(push: MyScheduleViewController(),
                                                            asRootViewController: true,
                                                            prefersProfileButton: true)
                    }
                })
            }
        })
    }

    @objc func cancelButtonTouchUpInside() {
        guard let driver = DriverManager.shared.driver else { return }

        if driver.passwordResetRequired {
            AppController.shared.logout()
        } else {
            if !self.popStep() {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // MARK: Validation methods
    func checkTextFieldsValidity() -> Bool {
        let enabled = (currentPasswordTextField.textField.text?.isMinimumPasswordLength() ?? false) &&
            (newPasswordTextField.textField.text?.isMinimumPasswordLength() ?? false) &&
            (passwordConfirmTextField.textField.text?.isMinimumPasswordLength() ?? false)
        
        self.nextButton.isEnabled = enabled
        
        return enabled
    }
    
    private func onLoginError(error: LuxeAPIError? = nil) {
        
        if let code = error?.code, code == .E2005 {
            AppController.shared.alert(title: Unlocalized.error, message: Unlocalized.invalidCredentials)
        } else {
            AppController.shared.alert(title: Unlocalized.error, message: Unlocalized.genericError)
        }
    }
    
    private func inlineError(error: String) {
        passwordConfirmTextField.applyErrorState()
        passwordConfirmTextField.setBottomRightText(bottomRightText: error.uppercased(), actionBlock: nil)
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            if textField == currentPasswordTextField.textField {
                newPasswordTextField.textField.becomeFirstResponder()
            } else {
                passwordConfirmTextField.textField.becomeFirstResponder()
            }
        } else {
            if checkTextFieldsValidity() {
                self.nextButtonTouchUpInside()
            }
        }
        return false
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        _ = checkTextFieldsValidity()
        if let text = passwordConfirmTextField.bottomRightLabel.text, text.count > 0 {
            passwordConfirmTextField.resetErrorState()
            passwordConfirmTextField.bottomRightLabel.text = ""
        }
    }
    
    // MARK: Step Data
    
    override func saveStepState() {
        if let step = self.step as? ForgotPasswordStep {
            step.currentPassword = self.currentPasswordTextField.text
            step.newPassword = self.newPasswordTextField.text
            step.confirmPassword = self.passwordConfirmTextField.text
        }
    }
    
    override func restoreStepState() {
        
        guard let step = self.step as? ForgotPasswordStep else {
            return
        }
        
        if let currentPwd = step.currentPassword {
            self.currentPasswordTextField.textField.text = currentPwd
            self.currentPasswordTextField.textField.becomeFirstResponder()
        }
        
        if let newPassword = step.newPassword {
            self.newPasswordTextField.textField.text = newPassword
            self.currentPasswordTextField.textField.becomeFirstResponder()
        }
        
        if let confirmPassword = step.confirmPassword {
            self.passwordConfirmTextField.textField.text = confirmPassword
            self.currentPasswordTextField.textField.becomeFirstResponder()
        }
    }

}

class ForgotPasswordStep: Step {
    
    var currentPassword: String?
    var newPassword: String?
    var confirmPassword: String?
    
    init() {
        super.init(title: Unlocalized.createPassword, controllerName: ForgotPasswordViewController.className)
    }
}
