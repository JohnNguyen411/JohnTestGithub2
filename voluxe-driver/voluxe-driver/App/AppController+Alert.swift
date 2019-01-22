//
//  AppController+Alert.swift
//  voluxe-driver
//
//  Created by Christoph on 1/4/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

extension AppController {

    func alert(title: String = Localized.genericAlertTitle,
               message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: Localized.ok, style: .cancel) {
            action in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func alert(title: String,
               message: String,
               completion: (() -> ())? = nil)
    {
        self.alert(title: title,
                   message: message,
                   buttonTitle: Localized.ok.uppercased(),
                   completion: completion)
    }
    
    
    // Alert with only one button
    func alert(title: String,
                    message: String,
                    buttonTitle: String,
                    completion: (() -> ())? = nil)
    {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        
        // Submit button
        let button = UIAlertAction(title: buttonTitle, style: .default) {
            _ in
            completion?()
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(button)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // Alert with Ok and Cancel button
    func alert(title: String,
               message: String,
               cancelButtonTitle: String,
               okButtonTitle: String,
               okCompletion: @escaping (() -> ()))
    {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        
        // cancel button
        let backAction = UIAlertAction(title: cancelButtonTitle, style: .default) {
            _ in
            alert.dismiss(animated: true, completion: nil)
        }
        
        // OK button
        let submitAction = UIAlertAction(title: okButtonTitle, style: .default) {
            _ in
            alert.dismiss(animated: true, completion: nil)
            okCompletion()
        }
        
        alert.addAction(backAction)
        alert.addAction(submitAction)
        self.present(alert, animated: true, completion: nil)
    }
}
