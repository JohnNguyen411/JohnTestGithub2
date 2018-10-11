//
//  FTUESignupNameViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 2/27/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import RealmSwift

class FTUESignupNameViewController: FTUEChildViewController, UITextFieldDelegate {
    
    let welcomeLabel: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.text = .viewSignupNameLabel
        textView.font = .volvoSansProRegular(size: 16)
        textView.volvoProLineSpacing()
        textView.volvoProLineSpacing()
        textView.textColor = .luxeDarkGray()
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
        
    let firstNameTextField = VLVerticalTextField(title: .viewEditTextTitleFirstName, placeholder: .viewEditTextInfoHintFirstName)
    let lastNameTextField = VLVerticalTextField(title: .viewEditTextTitleLastName, placeholder: .viewEditTextInfoHintLastName)
    
    var deeplinkEventConsumed = false
    var editMode = false

    init() {
        editMode = UserManager.sharedInstance.isLoggedIn()
        super.init(screen: editMode ? .nameUpdate : .signupName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()

        // support autofill
        self.firstNameTextField.textField.textContentType = .givenName
        self.lastNameTextField.textField.textContentType = .familyName
        
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

        canGoNext(nextEnabled: editMode ? true : false)
        
        if let customer = UserManager.sharedInstance.getCustomer(), editMode {
            self.firstNameTextField.textField.text = customer.firstName
            self.lastNameTextField.textField.text = customer.lastName
            self.navigationItem.rightBarButtonItem?.title = .done
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.firstNameTextField.textField.becomeFirstResponder()
        
        if editMode { return }
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
        
        super.setupViews()
        
        scrollView.addSubview(welcomeLabel)
        scrollView.addSubview(firstNameTextField)
        scrollView.addSubview(lastNameTextField)
        
        if editMode {
            welcomeLabel.isHidden = true
            
            firstNameTextField.snp.makeConstraints { (make) -> Void in
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalToSuperview().offset(-20)
                make.equalsToTop(view: self.view, offset: BaseViewController.defaultTopYOffset)
                make.height.equalTo(VLVerticalTextField.verticalHeight)
            }
        } else {
            welcomeLabel.snp.makeConstraints { (make) -> Void in
                make.leading.equalToSuperview().offset(20)
                make.equalsToTop(view: self.view, offset: BaseViewController.defaultTopYOffset)
                make.trailing.equalToSuperview().offset(-20)
            }
            
            firstNameTextField.snp.makeConstraints { (make) -> Void in
                make.leading.trailing.equalTo(welcomeLabel)
                make.top.equalTo(welcomeLabel.snp.bottom).offset(BaseViewController.defaultTopYOffset)
                make.height.equalTo(VLVerticalTextField.verticalHeight)
            }
        }
        
        lastNameTextField.snp.makeConstraints { (make) -> Void in
            make.leading.trailing.equalTo(firstNameTextField)
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
        textField.trimText()
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
        if editMode {
            self.updateCustomerName()
        } else {
            UserManager.sharedInstance.signupCustomer.lastName = lastNameTextField.textField.text
            UserManager.sharedInstance.signupCustomer.firstName = firstNameTextField.textField.text
            goToNext()
        }
    }
    
    override func goToNext() {
        self.pushViewController(FTUESignupEmailPhoneViewController(), animated: true)
    }
    
    func updateCustomerName() {
        guard let customerId = UserManager.sharedInstance.customerId(), let lastName = lastNameTextField.textField.text, let firstName = firstNameTextField.textField.text else { return }
        
        if let customer = UserManager.sharedInstance.getCustomer(), lastName == customer.lastName, firstName == customer.firstName {
            // same, don't update
            self.navigationController?.popViewController(animated: true)
            return
        }

        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        CustomerAPI().updateName(customerId: customerId, firstName: firstName, lastName: lastName).onSuccess { result in
            if let customer = UserManager.sharedInstance.getCustomer() {
                if let realm = try? Realm() {
                    try? realm.write {
                        customer.lastName = lastName
                        customer.firstName = firstName
                        UserManager.sharedInstance.setCustomer(customer: customer)
                        realm.add(customer, update: true)
                    }
                }
            }
            self.navigationController?.popViewController(animated: true)
            MBProgressHUD.hide(for: self.view, animated: true)
            }.onFailure { error in
                MBProgressHUD.hide(for: self.view, animated: true)
                self.showOkDialog(title: .error, message: .errorUnknown)
        }
    }
}
