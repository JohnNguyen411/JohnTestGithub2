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

    private let loginLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.text = "Automatically log in on launch (for development only)"
        return label
    }()

    private let loginToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.addTarget(self, action: #selector(loginToggleValueChanged), for: .valueChanged)
        return toggle
    }()

    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.text = "Update location (only when logged in)"
        return label
    }()

    private let locationToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.addTarget(self, action: #selector(locationToggleValueChanged), for: .valueChanged)
        return toggle
    }()

    private let locationField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.font = UIFont.systemFont(ofSize: 10)
        field.isUserInteractionEnabled = false
        field.placeholder = "No location"
        return field
    }()

    private let tokenField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.font = UIFont.systemFont(ofSize: 10)
        field.isUserInteractionEnabled = false
        field.placeholder = "No push token"
        return field
    }()

    // MARK:- Lifecycle

    convenience init() {

        self.init(nibName: nil, bundle: nil)

        DriverManager.shared.driverDidChangeClosure = {
            [weak self] driver in
            self?.updateUI()
        }

        DriverManager.shared.locationDidChangeClosure = {
            [weak self] location in
            self?.updateUI()
        }

        DriverManager.shared.pushTokenDidChangeClosure = {
            [weak self] token in
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

        gridView.add(subview: self.loginToggle, to: 1)
        self.loginToggle.pinTopToBottomOf(view: self.loginButton, spacing: 20)

        gridView.add(subview: self.loginLabel, from: 2, to: 6)
        self.loginLabel.pinTopToBottomOf(view: self.logoutButton, spacing: 20)
        self.loginLabel.heightAnchor.constraint(equalTo: self.loginToggle.heightAnchor).isActive = true

        gridView.add(subview: self.locationToggle, to: 1)
        self.locationToggle.pinTopToBottomOf(view: self.loginToggle, spacing: 20)

        gridView.add(subview: self.locationLabel, from: 2, to: 6)
        self.locationLabel.pinTopToBottomOf(view: self.loginLabel, spacing: 20)
        self.locationLabel.heightAnchor.constraint(equalTo: self.locationToggle.heightAnchor).isActive = true

        gridView.add(subview: self.locationField, from: 1, to: 6)
        self.locationField.pinTopToBottomOf(view: self.locationLabel, spacing: 20)

        gridView.add(subview: self.tokenField, from: 1, to: 6)
        self.tokenField.pinTopToBottomOf(view: self.locationField, spacing: 20)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.emailField.text = UserDefaults.standard.driverEmail
        self.passwordField.text = UserDefaults.standard.driverPassword
        self.updateUI()
    }

    // MARK:- Update UI

    private func updateUI() {
        let manager = DriverManager.shared
        let driver = manager.driver
        self.loginButton.isEnabled = driver == nil
        self.logoutButton.isEnabled = driver != nil
        self.loginToggle.isOn = UserDefaults.standard.loginOnLaunch
        self.locationToggle.isEnabled = manager.canUpdateLocation
        self.locationToggle.isOn = manager.isUpdatingLocation
        if let location = manager.location { self.locationField.text = "\(location)" }
        else { self.locationField.text = nil }
        self.tokenField.text = "\(manager.pushToken ?? "")"
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

    @objc func loginToggleValueChanged() {
        UserDefaults.standard.loginOnLaunch = self.loginToggle.isOn
    }

    @objc func locationToggleValueChanged() {
        let manager = DriverManager.shared
        self.locationToggle.isOn ? manager.startLocationUpdates() : manager.stopLocationUpdates()
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
