//
//  FTUELoginViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 10/31/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

class FTUELoginViewController: FTUEChildViewController, FTUEProtocol {
    
    let volvoIdTextField = VLVerticalTextField(title: .VolvoUserId, placeholder: .VolvoUserId_Placeholder)
    let volvoPwdTextField = VLVerticalTextField(title: .VolvoPassword, placeholder: "••••••••")
    let volvoVINTextField = VLVerticalTextField(title: .VehicleIdentificationNumber, placeholder: .VehicleIdentificationNumber_Placeholder)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        volvoIdTextField.accessibilityIdentifier = "volvoIdTextField"
        volvoPwdTextField.accessibilityIdentifier = "volvoPwdTextField"
        volvoVINTextField.accessibilityIdentifier = "volvoVINTextField"
        
        volvoIdTextField.textField.autocorrectionType = .no
        volvoPwdTextField.textField.autocorrectionType = .no
        volvoVINTextField.textField.autocorrectionType = .no
        volvoPwdTextField.textField.isSecureTextEntry = true
        
        volvoIdTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        volvoPwdTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        volvoVINTextField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        setupViews()
        
    }
    
    func setupViews() {
        
        self.view.addSubview(volvoIdTextField)
        self.view.addSubview(volvoPwdTextField)
        self.view.addSubview(volvoVINTextField)

        volvoIdTextField.snp.makeConstraints { (make) -> Void in
            make.left.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(80)
        }
        
        volvoPwdTextField.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(volvoIdTextField)
            make.top.equalTo(volvoIdTextField.snp.bottom)
            make.height.equalTo(80)
        }
        
        volvoVINTextField.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(volvoIdTextField)
            make.top.equalTo(volvoPwdTextField.snp.bottom)
            make.height.equalTo(80)
        }
    }
    
    //MARK: Validation methods

    func isVolvoIdValid(volvoId: String?) -> Bool {
        guard let volvoId = volvoId else {
            return false
        }
        
        if volvoId.isEmpty {
            return false
        }
        return true
    }
    
    func isPasswordValid(password: String?) -> Bool {
        guard let password = password else {
            return false
        }
        if password.isEmpty || password.count < 6 {
            return false
        }
        return true
    }
    
    
    func isVINValid(vin: String?) -> Bool {
        guard let vin = vin else {
            return false
        }
        if vin.isEmpty {
            return false
        }
        return true
    }
    
    
    func checkTextFieldsValidity() {
        canGoNext(nextEnabled: isVolvoIdValid(volvoId: volvoIdTextField.textField.text) && isPasswordValid(password: volvoPwdTextField.textField.text) && isVINValid(vin: volvoVINTextField.textField.text))
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        checkTextFieldsValidity()
    }
    
    //MARK: FTUEStartViewController
    func didSelectPage() {
        volvoIdTextField.textField.becomeFirstResponder()
        canGoNext(nextEnabled: false)
    }
}
