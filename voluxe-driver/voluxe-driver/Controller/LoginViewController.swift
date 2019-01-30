//
//  LoginViewController.swift
//  voluxe-driver
//
//  Created by Christoph on 12/22/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: StepViewController, UITextFieldDelegate {

    // MARK: Layout

    private let emailTextField = VLVerticalTextField(title: Localized.emailAddress, placeholder: Localized.emailAddressPlaceholder)
    private let passwordTextField = VLVerticalTextField(title: Localized.password, placeholder: "••••••••")
    private let cancelButton = UIButton.Volvo.secondary(title: Localized.cancel)
    private let nextButton = UIButton.Volvo.primary(title: Localized.next)
    private let forgotButton = UIButton.Volvo.text(title: Localized.forgotPassword)

    // MARK: Lifecycle

    convenience init() {
        self.init(title: Localized.signIn)
        self.addActions()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // support autofill
        if #available(iOS 11.0, *) {
            self.emailTextField.textField.textContentType = .username
            self.passwordTextField.textField.textContentType = .password
        }
        
        emailTextField.textField.autocorrectionType = .no
        passwordTextField.textField.autocorrectionType = .no
        passwordTextField.textField.isSecureTextEntry = true
        
        emailTextField.textField.keyboardType = .emailAddress
        emailTextField.textField.autocapitalizationType = .none
        
        emailTextField.textField.returnKeyType = .next
        passwordTextField.textField.returnKeyType = .done
        
        emailTextField.textField.delegate = self
        passwordTextField.textField.delegate = self
        
        emailTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        _ = checkTextFieldsValidity()

        self.view.backgroundColor = UIColor.Volvo.background.light

        let scrollView = Layout.scrollView(in: self)
        let contentView = Layout.verticalContentView(in: scrollView)
        let gridView = contentView.addGridLayoutView(with: GridLayout.volvoAgent())

        gridView.add(subview: self.emailTextField, from: 1, to: 6)
        self.emailTextField.pinToSuperviewTop(spacing: 40)
        self.emailTextField.heightAnchor.constraint(equalToConstant: CGFloat(VLVerticalTextField.height)).isActive = true

        gridView.add(subview: self.passwordTextField, from: 1, to: 6)
        self.passwordTextField.pinTopToBottomOf(view: self.emailTextField, spacing: 20)
        self.passwordTextField.heightAnchor.constraint(equalToConstant: CGFloat(VLVerticalTextField.height)).isActive = true

        gridView.add(subview: self.forgotButton, from: 4, to: 6)
        self.forgotButton.bottomAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 0).isActive = true
        
        gridView.add(subview: self.cancelButton, from: 1, to: 2)
        self.cancelButton.pinTopToBottomOf(view: passwordTextField, spacing: 40)

        gridView.add(subview: self.nextButton, from: 3, to: 4)
        self.nextButton.pinTopToBottomOf(view: passwordTextField, spacing: 40)
        
        self.view.setNeedsUpdateConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.emailTextField.textField.becomeFirstResponder()
    }

    // MARK: API Calls
    
    private func login(email: String, password: String) {
        DriverManager.shared.login(email: email, password: password) {
            [weak self] driver, error in
            
            AppController.shared.lookNotBusy()
            
            if let driver = driver {
                let steps = FlowViewController.loginSteps(for: driver)
                
                if steps.count == 0 {
                    self?.openMainController()
                } else {
                    AppController.shared.mainController(push: FlowViewController(steps: steps, direction: .horizontal),
                                                        asRootViewController: true,
                                                        prefersProfileButton: false)
                }
                
            } else if let error = error {
                // handle error
                self?.onLoginError(error: error)
            }
        }
        
    }
    
    private func openMainController() {
        let controller = MyScheduleViewController()
        AppController.shared.mainController(push: controller,
                                            asRootViewController: true,
                                            prefersProfileButton: true)
    }
    
    // MARK: Actions

    private func addActions() {
        self.nextButton.addTarget(self, action: #selector(nextButtonTouchUpInside), for: .touchUpInside)
        self.cancelButton.addTarget(self, action: #selector(cancelButtonTouchUpInside), for: .touchUpInside)
        self.forgotButton.addTarget(self, action: #selector(forgotButtonTouchUpInside), for: .touchUpInside)
    }

    @objc func nextButtonTouchUpInside() {
        AppController.shared.lookBusy()
        self.login(email: emailTextField.text, password: passwordTextField.text)
    }

    @objc func cancelButtonTouchUpInside() {
        AppController.shared.showLanding()
    }

    @objc func forgotButtonTouchUpInside() {
        AppController.shared.alert(title: Localized.forgotYourPassword, message: Localized.pleaseContactAdvisor)
    }
    
    // MARK: Validation methods
    func checkTextFieldsValidity() -> Bool {
        let enabled = String.isValid(email: emailTextField.textField.text) &&
            String.isValid(password: passwordTextField.textField.text)
        
        self.nextButton.isEnabled = enabled
        
        return enabled
    }
    
    private func onLoginError(error: LuxeAPIError? = nil) {
        
        if let code = error?.code, code == .E2005 {
            AppController.shared.alert(title: Localized.error, message: Localized.invalidCredentials)
        } else {
            AppController.shared.alert(title: Localized.error, message: Localized.genericError)
        }
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            passwordTextField.textField.becomeFirstResponder()
        } else {
            if checkTextFieldsValidity() {
                self.nextButtonTouchUpInside()
            }
        }
        return false
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        _ = checkTextFieldsValidity()
    }
    
}
