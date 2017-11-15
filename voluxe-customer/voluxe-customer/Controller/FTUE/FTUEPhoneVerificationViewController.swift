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
        textView.text = .PhoneNumberVerifLabel
        textView.font = .volvoSansLight(size: 18)
        textView.textColor = .luxeDarkGray()
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    override func viewDidLoad() {
        codeTextField.textField.delegate = self
        super.viewDidLoad()
        codeTextField.textField.keyboardType = .numberPad
        codeTextField.setRightButtonText(rightButtonText: (.ResendCode as String).uppercased(), actionBlock: {
            self.resendCode()
        })

        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(codeTextField)
        self.view.addSubview(phoneNumberLabel)
        
        let sizeThatFits = phoneNumberLabel.sizeThatFits(CGSize(width: view.frame.width - 40, height: CGFloat(MAXFLOAT)))

        phoneNumberLabel.snp.makeConstraints { (make) -> Void in
            make.left.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(sizeThatFits)
        }
        
        codeTextField.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(20)
            make.height.equalTo(40)
        }
        
    }
    
    @objc func resendCode() {
        
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
