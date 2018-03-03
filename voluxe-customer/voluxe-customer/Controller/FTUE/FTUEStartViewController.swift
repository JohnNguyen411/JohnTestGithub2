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

    let loginButton = VLButton(type: .BluePrimary, title: (.Login as String).uppercased(), actionBlock: nil)
    let signupButton = VLButton(type: .BluePrimary, title: (.Signup as String).uppercased(), actionBlock: nil)

    let logo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "volvo_logo")
        return imageView
    }()
    
    let appName: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.text = .AppName
        textView.font = .volvoSansLight(size: 26)
        textView.textColor = .luxeDarkBlue()
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    let text1: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.text = .FTUEStartOne
        textView.font = .volvoSansLight(size: 18)
        textView.textColor = .luxeDarkGray()
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    let text2: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.text = .FTUEStartTwo
        textView.font = .volvoSansLight(size: 18)
        textView.textColor = .luxeDarkGray()
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
            self.navigationController?.pushViewController(FTUESignupNameViewController(), animated: true)
        }
        
        //setupViews()
    }
    
    override func setupViews() {
        
        self.view.addSubview(logo)
        self.view.addSubview(appName)
        self.view.addSubview(text1)
        self.view.addSubview(text2)
        self.view.addSubview(loginButton)
        self.view.addSubview(signupButton)

        let sizeThatFits = text1.sizeThatFits(CGSize(width: view.frame.width - 40, height: CGFloat(MAXFLOAT)))
        
        logo.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(60)
            make.left.equalToSuperview().offset(20)
            make.width.height.equalTo(50)
        }
        
        appName.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(logo.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(80)
        }
        
        text1.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(appName.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(sizeThatFits.height)
        }
        
        text2.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(text1)
            make.top.equalTo(text1.snp.bottom).offset(20)
            make.height.equalTo(sizeThatFits.height)
        }
        
        loginButton.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.width.equalToSuperview().dividedBy(2).offset(-30)
            make.height.equalTo(VLButton.primaryHeight)
        }
        
        signupButton.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
            make.width.equalToSuperview().dividedBy(2).offset(-30)
            make.height.equalTo(VLButton.primaryHeight)
        }
    }
}

class SignupCustomer: NSObject {
    var firstName: String?
    var lastName: String?
    var phoneNumber: String?
    var email: String?
}
