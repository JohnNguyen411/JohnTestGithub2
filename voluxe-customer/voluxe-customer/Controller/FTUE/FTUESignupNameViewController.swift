//
//  FTUESignupNameViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 2/27/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

class FTUESignupNameViewController: FTUEChildViewController, FTUEProtocol {
    
    let welcomeLabel: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.text = .WelcomeSignup
        textView.font = .volvoSansLight(size: 18)
        textView.textColor = .luxeDarkGray()
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    let firstNameTextField = VLVerticalTextField(title: .FirstName, placeholder: .FirstNamePlaceholder)
    let lastNameTextField = VLVerticalTextField(title: .LastName, placeholder: .LastNamePlaceholder)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeLabel.accessibilityIdentifier = "welcomeLabel"
        firstNameTextField.accessibilityIdentifier = "firstNameTextField"
        lastNameTextField.accessibilityIdentifier = "lastNameTextField"
        
        firstNameTextField.textField.autocorrectionType = .no
        lastNameTextField.textField.autocorrectionType = .no
        
        firstNameTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        lastNameTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        setupViews()
        
    }
    
    func setupViews() {
        
        self.view.addSubview(welcomeLabel)
        self.view.addSubview(firstNameTextField)
        self.view.addSubview(lastNameTextField)
        
        welcomeLabel.snp.makeConstraints { (make) -> Void in
            make.left.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(80)
        }
        
        firstNameTextField.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(welcomeLabel)
            make.top.equalTo(welcomeLabel.snp.bottom)
            make.height.equalTo(80)
        }
        
        lastNameTextField.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(lastNameTextField)
            make.top.equalTo(lastNameTextField.snp.bottom)
            make.height.equalTo(80)
        }
    }
    
    //MARK: Validation methods
    
    func isFirstNameValid(firstName: String?) -> Bool {
        guard let firstName = firstName else {
            return false
        }
        
        if firstName.isEmpty {
            return false
        }
        return true
    }
    
    func isLastNameValid(lastName: String?) -> Bool {
        guard let lastName = lastName else {
            return false
        }
        if lastName.isEmpty || lastName.count < 6 {
            return false
        }
        return true
    }
    
    override func checkTextFieldsValidity() {
        canGoNext(nextEnabled: isFirstNameValid(firstName: firstNameTextField.textField.text) && isLastNameValid(lastName: lastNameTextField.textField.text))
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        checkTextFieldsValidity()
    }
    
    //MARK: FTUEStartViewController
    func didSelectPage() {
        firstNameTextField.textField.becomeFirstResponder()
        canGoNext(nextEnabled: false)
    }
}
