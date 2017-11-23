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

class FTUEPhoneNumberViewController: FTUEChildViewController, FTUEProtocol {
    
    let phoneNumberTextField = VLVerticalTextField(title: .MobilePhoneNumber, placeholder: .MobilePhoneNumber_Placeholder, isPhoneNumber: true)
    let phoneNumberKit = PhoneNumberKit()

    let phoneNumberLabel: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.text = .MobilePhoneNumberExplain
        textView.font = .volvoSansLight(size: 18)
        textView.textColor = .luxeDarkGray()
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    let phoneNumberConfirmLabel: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.font = .volvoSansLight(size: 12)
        textView.textColor = .luxeDarkGray()
        textView.text = .MobilePhoneNumberConfirm
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneNumberTextField.accessibilityIdentifier = "phoneNumberTextField"
        phoneNumberTextField.textField.keyboardType = .phonePad
        phoneNumberTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        let phoneNumberTF: PhoneNumberTextField = phoneNumberTextField.textField as! PhoneNumberTextField
        phoneNumberTF.maxDigits = 10
        
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(phoneNumberTextField)
        self.view.addSubview(phoneNumberLabel)
        self.view.addSubview(phoneNumberConfirmLabel)
                
        let sizeThatFits = phoneNumberLabel.sizeThatFits(CGSize(width: view.frame.width-40, height: CGFloat(MAXFLOAT)))

        phoneNumberLabel.snp.makeConstraints { (make) -> Void in
            make.left.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(sizeThatFits)
        }
        
        phoneNumberTextField.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(15)
            make.height.equalTo(VLVerticalTextField.height)
        }
        
        phoneNumberConfirmLabel.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(phoneNumberLabel)
            make.top.equalTo(phoneNumberTextField.snp.bottom)
            make.height.equalTo(20)
        }
    }
    
    func isPhoneNumberValid(phoneNumber: String?) -> Bool {
        guard let phoneNumber = phoneNumber else {
            return false
        }
        
        guard let textField = phoneNumberTextField.textField as? PhoneNumberTextField else {
            return false
        }
        
        do {
            let _ = try phoneNumberKit.parse(phoneNumber, withRegion: textField.currentRegion, ignoreType: true)
            return true
        } catch {
            return false
        }
 
    }
    
    
    
    override func checkTextFieldsValidity() {
        canGoNext(nextEnabled: isPhoneNumberValid(phoneNumber: phoneNumberTextField.textField.text))
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        checkTextFieldsValidity()
    }
    
    //MARK: FTUEStartViewController
    func didSelectPage() {
        phoneNumberTextField.textField.becomeFirstResponder()
        checkTextFieldsValidity()
    }
}
