//
//  AutoFillViewController.swift
//  voluxe-customer
//
//  Created by Christoph on 9/24/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class AutoFillViewController: UIViewController {

    override func viewDidLoad() {

        super.viewDidLoad()
        self.view.backgroundColor = .white

        // VLScrollView causes autolayout warnings
        let contentView = self.view!//UIScrollView(frame: .zero)
//        let contentView = VLScrollView()
//        self.view.addSubview(contentView)
//        contentView.snp.makeConstraints {
//            make in
//            make.edges.equalToSuperview()
//        }

        let usernameField = UITextField(frame: .zero)
        usernameField.borderStyle = .roundedRect
        usernameField.placeholder = "Email"
        usernameField.textAlignment = .center
        if #available(iOS 11.0, *) {
            usernameField.textContentType = .username
        }
        contentView.addSubview(usernameField)
        usernameField.snp.makeConstraints {
            make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(100)
            make.trailing.equalToSuperview().inset(20)
        }

        let passwordField = UITextField(frame: .zero)
        passwordField.borderStyle = .roundedRect
        passwordField.placeholder = "Password"
        passwordField.textAlignment = .center
        if #available(iOS 11.0, *) {
            passwordField.textContentType = .password
        }
        contentView.addSubview(passwordField)
        passwordField.snp.makeConstraints {
            make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(usernameField.snp.bottom).offset(10)
            make.trailing.equalToSuperview().inset(20)
        }

        let luxeUsernameField = VLVerticalTextField(title: "Email", placeholder: "Email")
        luxeUsernameField.textField.autocorrectionType = .no
        luxeUsernameField.textField.keyboardType = .emailAddress
        luxeUsernameField.textField.returnKeyType = .next
        luxeUsernameField.showLabels()
        if #available(iOS 11.0, *) {
            luxeUsernameField.textField.textContentType = .username
        }
        contentView.addSubview(luxeUsernameField)
        luxeUsernameField.snp.makeConstraints {
            make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(200)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(VLVerticalTextField.verticalHeight)
        }

        let luxePasswordField = VLVerticalTextField(title: "Password", placeholder: "••••••••")
        luxePasswordField.textField.autocorrectionType = .no
        luxePasswordField.textField.isSecureTextEntry = true
        luxePasswordField.textField.returnKeyType = .done
        luxePasswordField.showLabels()
        if #available(iOS 11.0, *) {
            luxePasswordField.textField.textContentType = .password
        }
        contentView.addSubview(luxePasswordField)
        luxePasswordField.snp.makeConstraints {
            make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(luxeUsernameField.snp.bottom).offset(10)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(VLVerticalTextField.verticalHeight)
        }
    }

    // Becoming first responder too soon will cause AutoFill to only fill
    // the selected field, not both fields.  viewDidAppear() is the earliest
    // it can be called.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        usernameField.becomeFirstResponder()
//        luxeUsernameField.textField.becomeFirstResponder()
    }
}
