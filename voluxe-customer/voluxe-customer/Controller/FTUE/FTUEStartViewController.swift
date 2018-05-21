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

class FTUEStartViewController: BaseViewController {
    
    enum FTUEFlowType {
        case login
        case signup
    }
    
    var realm : Realm?

    public static var flowType: FTUEFlowType = .login
    
    let loginButton = VLButton(type: .blueSecondary, title: (.SignIn as String).uppercased(), kern: UILabel.uppercasedKern(), eventName: AnalyticsConstants.eventClickSignin, screenName: AnalyticsConstants.paramNameLandingView)
    
    let signupButton = VLButton(type: .blueSecondary, title: (.CreateAccount as String).uppercased(), kern: UILabel.uppercasedKern(), eventName: AnalyticsConstants.eventClickCreateAccount, screenName: AnalyticsConstants.paramNameLandingView)

    let logo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "luxeByVolvo")
        return imageView
    }()
    
    let pipeSeparator: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.text = "|"
        textView.font = .volvoSansLight(size: 12)
        textView.textColor = .luxeLightGray()
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
  
    
    init() {
        super.init(screenName: AnalyticsConstants.paramNameLandingView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try? Realm()

        UserManager.sharedInstance.signupCustomer = SignupCustomer()

        loginButton.setActionBlock {
            //login
            UserManager.sharedInstance.signupCustomer = SignupCustomer()
            FTUEStartViewController.flowType = .login
            self.navigationController?.pushViewController(FTUELoginViewController(), animated: true)
        }
        
        signupButton.setActionBlock {
            //signup
            UserManager.sharedInstance.signupCustomer = SignupCustomer()
            FTUEStartViewController.flowType = .signup
            self.navigationController?.pushViewController(FTUESignupNameViewController(), animated: true)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // reset current customer
        if let realm = self.realm {
            try? realm.write {
                realm.deleteAll()
            }
        }
        UserManager.sharedInstance.setCustomer(customer: nil)
        UserManager.sharedInstance.tempCustomerId = nil
    }
    
    override func setupViews() {
        
        loginButton.contentHorizontalAlignment = .right
        signupButton.contentHorizontalAlignment = .left
        
        self.view.addSubview(logo)

        let buttonContainer = UIView(frame: .zero)
        self.view.addSubview(buttonContainer)
        buttonContainer.addSubview(pipeSeparator)
        buttonContainer.addSubview(loginButton)
        buttonContainer.addSubview(signupButton)
        
        logo.snp.makeConstraints { (make) -> Void in
            make.equalsToTop(view: self.view, offset: 120)
            make.centerX.equalToSuperview()
        }
        
        buttonContainer.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.equalsToBottom(view: self.view, offset: -40)
            make.width.equalTo(180)
            make.height.equalTo(VLButton.primaryHeight)
        }
        
        loginButton.snp.makeConstraints { (make) -> Void in
            make.left.centerY.equalToSuperview()
            make.height.equalTo(VLButton.primaryHeight)
        }
        
        pipeSeparator.snp.makeConstraints { (make) -> Void in
            make.centerY.equalToSuperview()
            make.left.equalTo(loginButton.snp.right).offset(10)
            make.height.equalTo(VLButton.primaryHeight)
        }
        
        signupButton.snp.makeConstraints { (make) -> Void in
            make.centerY.equalToSuperview()
            make.left.equalTo(pipeSeparator.snp.right).offset(10)
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
