//
//  FTUELoginViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 10/31/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

class FTUELoginViewController: UIViewController, FTUEProtocol {
    
    let volvoIdTextField = VLVerticalTextField(title: .VolvoUserId, placeholder: .VolvoUserId_Placeholder)
    let volvoPwdTextField = VLVerticalTextField(title: .VolvoPassword, placeholder: "••••••••")
    let volvoVINTextField = VLVerticalTextField(title: .VehicleIdentificationNumber, placeholder: .VehicleIdentificationNumber_Placeholder)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        volvoIdTextField.textField.autocorrectionType = .no
        volvoPwdTextField.textField.autocorrectionType = .no
        volvoVINTextField.textField.autocorrectionType = .no
        volvoPwdTextField.textField.isSecureTextEntry = true
        
        setupViews()
    }
    
    func setupViews() {
        
        self.view.addSubview(volvoIdTextField)
        self.view.addSubview(volvoPwdTextField)
        self.view.addSubview(volvoVINTextField)

        volvoIdTextField.snp.makeConstraints { (make) -> Void in
            make.left.top.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
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
    
    //MARK: FTUEStartViewController
    func didSelectPage() {
        volvoIdTextField.textField.becomeFirstResponder()
    }
}
