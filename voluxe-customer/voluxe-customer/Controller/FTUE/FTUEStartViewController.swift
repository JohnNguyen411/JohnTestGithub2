//
//  FTUEStartViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 10/31/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

class FTUEStartViewController: BaseViewController {
    
    enum FTUEFlowType {
        case login
        case signup
    }
    
    public static var flowType: FTUEFlowType = .login

    let loginButton = VLButton(type: .blueSecondary, title: (.SignIn as String).uppercased(), actionBlock: nil)
    let signupButton = VLButton(type: .blueSecondary, title: (.CreateAccount as String).uppercased(), actionBlock: nil)

    let logo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "volvo_logo")
        return imageView
    }()
    
    let pipeSeparator: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.text = "|"
        textView.font = .volvoSansLight(size: 12)
        textView.textColor = .luxeDarkGray()
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    let appName: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.text = .AppName
        textView.font = .volvoSansLight(size: 40)
        textView.textColor = .luxeDarkBlue()
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            self.navigationController?.pushViewController(FTUEAddVehicleViewController(), animated: true)
        }
        
        //setupViews()
    }
    
    override func setupViews() {
        
        loginButton.contentHorizontalAlignment = .right
        signupButton.contentHorizontalAlignment = .left
        
        let container = UIView(frame: .zero)
        self.view.addSubview(container)
        container.addSubview(logo)
        container.addSubview(appName)
        
        let buttonContainer = UIView(frame: .zero)
        self.view.addSubview(buttonContainer)
        buttonContainer.addSubview(pipeSeparator)
        buttonContainer.addSubview(loginButton)
        buttonContainer.addSubview(signupButton)
        
        container.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(120)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(100)
        }
        
        logo.snp.makeConstraints { (make) -> Void in
            make.left.centerY.equalToSuperview()
            make.width.height.equalTo(70)
        }
        
        appName.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(logo)
            make.left.equalTo(logo.snp.right).offset(20)
            make.height.equalTo(80)
        }
        
        buttonContainer.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-40)
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
