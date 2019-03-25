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
    
    let emailTextField = VLVerticalTextField(title: .localized(.emailAddress), placeholder: .localized(.viewEditTextInfoHintEmail))

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
        emailTextField.textField.textContentType = .emailAddress
        emailTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        if let customer = UserManager.sharedInstance.getCustomer() {
            emailTextField.textField.text = customer.email
        }
        emailTextField.textField.becomeFirstResponder()
        
        self.navigationItem.rightBarButtonItem?.title = .localized(.done)

    }
    override func setupViews() {
        
        self.view.addSubview(emailTextField)
        
        emailTextField.snp.makeConstraints { (make) -> Void in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.equalsToTop(view: self.view, offset: BaseViewController.defaultTopYOffset)
            make.height.equalTo(VLVerticalTextField.verticalHeight)
        }
        
    }
    
    //MARK: Validation methods
    
    private func onError(error: LuxeAPIError? = nil) {
        MBProgressHUD.hide(for: self.view, animated: true)
        
        if let code = error?.code {
            if code == .E5001 || code == .E4011 {
                self.showOkDialog(title: .localized(.error), message: .localized(.errorEmailAlreadyExist), dialog: .error, screen: self.screen)
            }
        } else {
            self.showOkDialog(title: .localized(.error), message: .localized(.errorUnknown), dialog: .error, screen: self.screen)
        }
    }
   
    override func checkTextFieldsValidity() -> Bool {
        let enabled = String.isValid(email: self.emailTextField.textField.text)
        canGoNext(nextEnabled: enabled)
        return enabled
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        textField.trimText()
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
        
        VolvoValetCustomerAPI.updateEmail(customerId: customerId, email: email) { error in
            // error
            if let error = error {
                self.onError(error: error)
            } else {
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
            }
        }
    }
    
    override func goToNext() {
    }
}


