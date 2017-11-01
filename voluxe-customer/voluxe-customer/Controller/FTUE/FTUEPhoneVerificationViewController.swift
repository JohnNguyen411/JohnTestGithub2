//
//  FTUEPhoneVerificationViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 10/31/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

class FTUEPhoneVerificationViewController: UIViewController, UITextFieldDelegate, FTUEProtocol {
    
    let codeTextField = VLVerticalTextField(title: "", placeholder: .PhoneNumberVerif_Placeholder)
    
    let phoneNumberLabel: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.font = Fonts.FONT_B2
        textView.text = .PhoneNumberVerifLabel
        textView.textColor = .white
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    let resendCodeLabel: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.font = Fonts.FONT_B4
        textView.text = .ResendCode
        textView.textColor = .white
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    override func viewDidLoad() {
        codeTextField.textField.delegate = self
        super.viewDidLoad()
        codeTextField.textField.keyboardType = .numberPad
        resendCodeLabel.textAlignment = .right

        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("viewDidDisappear")
        super.viewDidDisappear(animated)
    }
    
    func setupViews() {
        
        self.view.addSubview(codeTextField)
        self.view.addSubview(phoneNumberLabel)
        self.view.addSubview(resendCodeLabel)
        
        let sizeThatFits = phoneNumberLabel.sizeThatFits(CGSize(width: view.frame.width, height: CGFloat(MAXFLOAT)))

        phoneNumberLabel.snp.makeConstraints { (make) -> Void in
            make.left.top.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(sizeThatFits)
        }
        
        codeTextField.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.right.equalToSuperview().offset(-5)
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        
        resendCodeLabel.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(phoneNumberLabel)
            make.right.equalTo(phoneNumberLabel).offset(-5)
            make.top.equalTo(codeTextField.snp.top).offset(15)
            make.height.equalTo(20)
        }
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("textField shouldChangeCharactersIn")
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 4 // Bool
    }
    
    //MARK: FTUEStartViewController
    func didSelectPage() {
        codeTextField.textField.becomeFirstResponder()
    }

}
