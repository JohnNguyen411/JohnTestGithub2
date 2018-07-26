//
//  EditEmailViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 7/25/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift
import MBProgressHUD

class EditEmailViewController: FTUEChildViewController, UITextFieldDelegate {
    
    let emailTextField = VLVerticalTextField(title: .EmailAddress, placeholder: .EmailPlaceholder)

    var realm : Realm?
    
    init() {
        super.init(screen: .emailUpdate)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realm = try? Realm()
        
        emailTextField.accessibilityIdentifier = "emailTextField"
        emailTextField.textField.autocorrectionType = .no
        emailTextField.textField.keyboardType = .emailAddress
        emailTextField.textField.autocapitalizationType = .none
        emailTextField.textField.returnKeyType = .next
        emailTextField.textField.delegate = self
        emailTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        if let customer = UserManager.sharedInstance.getCustomer() {
            emailTextField.textField.text = customer.email
        }
        emailTextField.textField.becomeFirstResponder()
        
        self.navigationItem.rightBarButtonItem?.title = .Done

    }
    override func setupViews() {
        
        self.view.addSubview(emailTextField)
        
        emailTextField.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.equalsToTop(view: self.view, offset: BaseViewController.defaultTopYOffset)
            make.height.equalTo(VLVerticalTextField.verticalHeight)
        }
        
    }
    
    //MARK: Validation methods
    
    
    func isEmailValid(email: String?) -> Bool {
        guard let email = email else { return false }
        if email.isEmpty { return false }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    
    private func onError(error: Errors? = nil) {
        MBProgressHUD.hide(for: self.view, animated: true)
        
        if let apiError = error?.apiError {
            if apiError.getCode() == .E5001 || apiError.getCode() == .E4011 {
                self.showOkDialog(title: .Error, message: .AccountAlreadyExistUpdate, dialog: .error, screen: self.screen)
            }
        } else {
            self.showOkDialog(title: .Error, message: .GenericError, dialog: .error, screen: self.screen)
        }
    }
   
    override func checkTextFieldsValidity() -> Bool {
        let enabled = isEmailValid(email: emailTextField.textField.text)
        canGoNext(nextEnabled: enabled)
        return enabled
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        _ = checkTextFieldsValidity()
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if checkTextFieldsValidity() {
            self.onRightClicked()
        } else {
            // show error
        }
        return false
    }
    
    //MARK: FTUEStartViewController
    
    override func onRightClicked() {
        super.onRightClicked()
        
        guard let customerId = UserManager.sharedInstance.customerId(), let email = emailTextField.textField.text else { return }
        
        if let customer = UserManager.sharedInstance.getCustomer(), email == customer.email {
            // same, don't update
            self.navigationController?.popViewController(animated: true)
            return
        }

        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        CustomerAPI().updateEmail(customerId: customerId, email: email).onSuccess { result in
            // success
            if let customer = UserManager.sharedInstance.getCustomer() {
                if let realm = try? Realm() {
                    try? realm.write {
                        customer.email = email
                        UserManager.sharedInstance.setCustomer(customer: customer)
                        realm.add(customer, update: true)
                    }
                }
            }
            MBProgressHUD.hide(for: self.view, animated: true)
            self.navigationController?.popViewController(animated: true)
            }.onFailure { error in
                self.onError(error: error)
        }
    }
    
    override func goToNext() {
    }
}


