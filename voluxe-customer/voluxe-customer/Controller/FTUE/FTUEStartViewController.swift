//
//  FTUEStartViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 10/31/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class FTUEStartViewController: LogoViewController {

    enum FTUEFlowType {
        case login
        case signup
    }

    var realm : Realm?
    var deeplinkEventConsumed = false

    public static var flowType: FTUEFlowType = .login

    let loginButton = VLButton(type: .blueSecondary, title: (.viewIntroFooterSignin as String).uppercased(), kern: UILabel.uppercasedKern(), event: .signIn, screen: .landing)

    let signupButton = VLButton(type: .blueSecondary, title: (.viewIntroFooterSignup as String).uppercased(), kern: UILabel.uppercasedKern(), event: .createAccount, screen: .landing)


    let pipeSeparator: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.text = "|"
        textView.font = .volvoSansProRegular(size: 12)
        textView.textColor = .luxeLightGray()
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()


    init() {
        super.init(screen: .landing)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try? Realm()

        UserManager.sharedInstance.signupCustomer = SignupCustomer()

        loginButton.setActionBlock { [weak self] in
            //login
            UserManager.sharedInstance.signupCustomer = SignupCustomer()
            FTUEStartViewController.flowType = .login
            self?.pushViewController(FTUELoginViewController(), animated: true)
        }

        signupButton.setActionBlock { [weak self] in
            //signup
            UserManager.sharedInstance.signupCustomer = SignupCustomer()
            FTUEStartViewController.flowType = .signup
            self?.pushViewController(FTUESignupNameViewController(), animated: true)
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UserManager.sharedInstance.setCustomer(customer: nil)
        UserManager.sharedInstance.tempCustomerId = nil

        // check realm integrity
        guard let realm = self.realm else {
            self.showOkDialog(title: .error, message: .errorDatabase, dialog: .error, screen: self.screen)
            return
        }

        // reset current customer
        try? realm.write {
            realm.deleteAll()
        }

        if DeeplinkManager.sharedInstance.isPrefillSignup() && !deeplinkEventConsumed {
            UserManager.sharedInstance.signupCustomer = SignupCustomer()
            FTUEStartViewController.flowType = .signup
            if DeeplinkManager.sharedInstance.prefillSignupContinue {
                self.pushViewController(FTUESignupNameViewController(), animated: true)
            }
            deeplinkEventConsumed = true
        } else if deeplinkEventConsumed {
            DeeplinkManager.sharedInstance.prefillSignupContinue = false
        }

    }

    override func setupViews() {
        super.setupViews()
        loginButton.contentHorizontalAlignment = .right
        signupButton.contentHorizontalAlignment = .left

        let buttonContainer = UIView(frame: .zero)
        self.view.addSubview(buttonContainer)
        buttonContainer.addSubview(pipeSeparator)
        buttonContainer.addSubview(loginButton)
        buttonContainer.addSubview(signupButton)

        buttonContainer.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.equalsToBottom(view: self.view, offset: -40)
            make.width.equalTo(180)
            make.height.equalTo(VLButton.primaryHeight)
        }

        loginButton.snp.makeConstraints { (make) -> Void in
            make.leading.centerY.equalToSuperview()
            make.height.equalTo(VLButton.primaryHeight)
        }

        pipeSeparator.snp.makeConstraints { (make) -> Void in
            make.centerY.equalToSuperview()
            make.leading.equalTo(loginButton.snp.right).offset(10)
            make.height.equalTo(VLButton.primaryHeight)
        }

        signupButton.snp.makeConstraints { (make) -> Void in
            make.centerY.equalToSuperview()
            make.leading.equalTo(pipeSeparator.snp.right).offset(10)
            make.height.equalTo(VLButton.primaryHeight)
        }
    }
}

class SignupCustomer: NSObject {
    var firstName: String?
    var lastName: String?
    var phoneNumber: String?
    var email: String?
    var verificationCode: String?
}
