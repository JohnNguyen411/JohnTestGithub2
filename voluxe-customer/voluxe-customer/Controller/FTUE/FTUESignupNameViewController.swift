//
//  FTUESignupNameViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 2/27/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

class FTUESignupNameViewController: FTUEChildViewController, UITextFieldDelegate {
    
    let welcomeLabel: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.text = .WelcomeSignup
        textView.font = .volvoSansProRegular(size: 16)
        textView.volvoProLineSpacing()
        textView.volvoProLineSpacing()
        textView.textColor = .luxeDarkGray()
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    let firstNameTextField = VLVerticalTextField(title: .FirstName, placeholder: .FirstNamePlaceholder)
    let lastNameTextField = VLVerticalTextField(title: .LastName, placeholder: .LastNamePlaceholder)
    
    var deeplinkEventConsumed = false
    
    init() {
        super.init(screen: .signupName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeLabel.accessibilityIdentifier = "welcomeLabel"
        firstNameTextField.accessibilityIdentifier = "firstNameTextField"
        lastNameTextField.accessibilityIdentifier = "lastNameTextField"
        
        firstNameTextField.textField.returnKeyType = .next
        firstNameTextField.textField.autocorrectionType = .no
        lastNameTextField.textField.autocorrectionType = .no
        lastNameTextField.textField.returnKeyType = .done
        
        firstNameTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        lastNameTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        firstNameTextField.textField.delegate = self
        lastNameTextField.textField.delegate = self
        
        
        firstNameTextField.textField.becomeFirstResponder()
        canGoNext(nextEnabled: false)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if DeeplinkManager.sharedInstance.isPrefillSignup() && !deeplinkEventConsumed {
            if let firstName = DeeplinkManager.sharedInstance.getDeeplinkObject()?.firstName {
                firstNameTextField.textField.text = firstName
            }
            if let lastName = DeeplinkManager.sharedInstance.getDeeplinkObject()?.lastName {
                lastNameTextField.textField.text = lastName
            }
            
            deeplinkEventConsumed = true
            
            if checkTextFieldsValidity() {
                if DeeplinkManager.sharedInstance.prefillSignupContinue {
                    self.onRightClicked()
                }
            }
        }
    }
    
    override func setupViews() {
        
        self.view.addSubview(welcomeLabel)
        self.view.addSubview(firstNameTextField)
        self.view.addSubview(lastNameTextField)
        
        welcomeLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(20)
            make.equalsToTop(view: self.view, offset: BaseViewController.defaultTopYOffset)
            make.right.equalToSuperview().offset(-20)
        }
        
        firstNameTextField.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(welcomeLabel)
            make.top.equalTo(welcomeLabel.snp.bottom).offset(BaseViewController.defaultTopYOffset)
            make.height.equalTo(VLVerticalTextField.verticalHeight)
        }
        
        lastNameTextField.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(firstNameTextField)
            make.top.equalTo(firstNameTextField.snp.bottom)
            make.height.equalTo(VLVerticalTextField.verticalHeight)
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
        guard let lastName = lastName else { return false }
        if lastName.isEmpty { return false }
        
        return true
    }
    
    override func checkTextFieldsValidity() -> Bool {
        let enabled = isFirstNameValid(firstName: firstNameTextField.textField.text) && isLastNameValid(lastName: lastNameTextField.textField.text)
        canGoNext(nextEnabled: enabled)
        return enabled
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        _ = checkTextFieldsValidity()
    }
    
    // MARK:- UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            lastNameTextField.textField.becomeFirstResponder()
        } else {
            if checkTextFieldsValidity() {
                self.onRightClicked()
            } else {
                // show error
            }
        }
        return false
    }
    
    // MARK:- FTUEStartViewController

    override func onRightClicked() {
        super.onRightClicked()
        UserManager.sharedInstance.signupCustomer.lastName = lastNameTextField.textField.text
        UserManager.sharedInstance.signupCustomer.firstName = firstNameTextField.textField.text
        goToNext()
    }
    
    override func goToNext() {
        self.pushViewController(FTUESignupEmailPhoneViewController(), animated: true)
    }
}
