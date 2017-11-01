//
//  FTUEPhoneNumberViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 10/31/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
import PhoneNumberKit

class FTUEPhoneNumberViewController: UIViewController {
    
    let phoneNumberTextField = VLVerticalTextField(title: .MobilePhoneNumber, placeholder: .MobilePhoneNumber_Placeholder, isPhoneNumber: true)
    
    let phoneNumberLabel: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.font = Fonts.FONT_B2
        textView.text = .MobilePhoneNumberExplain
        textView.textColor = .white
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        return textView
    }()
    
    let phoneNumberConfirmLabel: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.font = Fonts.FONT_B4
        textView.text = .MobilePhoneNumberConfirm
        textView.textColor = .white
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneNumberTextField.textField.keyboardType = .phonePad
        
        let phoneNumberTF: PhoneNumberTextField = phoneNumberTextField.textField as! PhoneNumberTextField
        phoneNumberTF.maxDigits = 10
        
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(phoneNumberTextField)
        self.view.addSubview(phoneNumberLabel)
        self.view.addSubview(phoneNumberConfirmLabel)
                
        
        phoneNumberLabel.snp.makeConstraints { (make) -> Void in
            make.left.top.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(60)
        }
        
        phoneNumberTextField.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.top.equalTo(phoneNumberLabel.snp.bottom)
            make.height.equalTo(60)
        }
        
        phoneNumberConfirmLabel.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(phoneNumberLabel)
            make.top.equalTo(phoneNumberTextField.snp.bottom)
            make.height.equalTo(20)
        }
    }
}
