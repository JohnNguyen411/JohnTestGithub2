//
//  DriverManagerViewController.swift
//  voluxe-driver
//
//  Created by Christoph on 12/3/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class DriverManagerViewController: UIViewController {

    private let emailField: UITextField = {
        let field = UITextField()
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.borderStyle = .roundedRect
        field.keyboardType = .emailAddress
        field.placeholder = "Driver email address"
        field.textContentType = .emailAddress
        return field
    }()

    private let passwordField: UITextField = {
        let field = UITextField()
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.borderStyle = .roundedRect
        field.keyboardType = .asciiCapable
        field.isSecureTextEntry = true
        field.placeholder = "Password"
        field.textContentType = .password
        return field
    }()

    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.addTarget(self, action: #selector(loginButtonTouchUpInside), for: .touchUpInside)
        return button
    }()

    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.addTarget(self, action: #selector(logoutButtonTouchUpInside), for: .touchUpInside)
        return button
    }()

    // MARK:- Lifecycle

    convenience init() {
        self.init(nibName: nil, bundle: nil)
        DriverManager.shared.driverDidChangeClosure = {
            [weak self] driver in
            self?.updateUI()
        }
    }

    deinit {
        DriverManager.shared.driverDidChangeClosure = nil
    }

    override func viewDidLoad() {

        super.viewDidLoad()
        self.view.backgroundColor = .white

        let scrollView = Layout.scrollView(in: self)
        let contentView = Layout.verticalContentView(in: scrollView)
        let gridView = contentView.addGridLayoutView()

        gridView.add(subview: self.emailField, from: 1, to: 6)
        self.emailField.pinToSuperviewTop(spacing: 20)

        gridView.add(subview: self.passwordField, from: 1, to: 6)
        self.passwordField.pinTopToBottomOf(view: self.emailField, spacing: 20)

        gridView.add(subview: self.loginButton, from: 2, to: 3)
        self.loginButton.pinTopToBottomOf(view: self.passwordField, spacing: 20)

        gridView.add(subview: self.logoutButton, from: 4, to: 5)
        self.logoutButton.pinTopToBottomOf(view: self.passwordField, spacing: 20)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.emailField.text = UserDefaults.standard.driverEmail
        self.passwordField.text = UserDefaults.standard.driverPassword
        self.updateUI()
    }

    // MARK:- Update UI

    private func updateUI() {
        let driver = DriverManager.shared.driver
        self.loginButton.isEnabled = driver == nil
        self.logoutButton.isEnabled = driver != nil
    }

    // MARK:- Actions

    @objc func loginButtonTouchUpInside() {
        UserDefaults.standard.driverEmail = self.emailField.text
        UserDefaults.standard.driverPassword = self.passwordField.text
        guard let email = self.emailField.text else { return }
        guard let password = self.passwordField.text else { return }
        self.loginButton.isEnabled = false
        DriverManager.shared.login(email: email, password: password) {
            [weak self] driver in
            self?.updateUI()
        }
    }

    @objc func logoutButtonTouchUpInside() {
        DriverManager.shared.logout()
        self.updateUI()
    }
}

// MARK:- Unsecure extension to store driver info

extension UserDefaults {

    // IMPORTANT
    // This is unsecure, do not ship, use only for debugging/development!
    var driverEmail: String? {
        get {
            return self.string(forKey: #function)
        }
        set {
            self.setValue(newValue, forKey: #function)
        }
    }

    // IMPORTANT!
    // This is unsecure, do not ship, use only for debugging/development!
    var driverPassword: String? {
        get {
            return self.string(forKey: #function)
        }
        set {
            self.setValue(newValue, forKey: #function)
        }
    }
}
