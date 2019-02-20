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
    
    func alert(title: String = Unlocalized.genericAlertTitle,
               message: String,
               dialog: AnalyticsEnums.Name.Screen? = nil,
               screen: AnalyticsEnums.Name.Screen? = nil)
    {
        if let dialog = dialog { Analytics.trackView(screen: dialog, from: screen) }

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: Unlocalized.ok, style: .cancel) {
            action in
            Analytics.trackClick(button: .dismissDialog, screen: dialog)

            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func alert(title: String,
               message: String,
               completion: (() -> ())? = nil,
               dialog: AnalyticsEnums.Name.Screen? = nil,
               screen: AnalyticsEnums.Name.Screen? = nil)
    {
        self.alert(title: title,
                   message: message,
                   buttonTitle: Unlocalized.ok.uppercased(),
                   completion: completion, dialog: dialog, screen: screen)
    }
    
    func alertGeneric(for error: LuxeAPIError?, retry: Bool, completion: (() -> ())? = nil,
                      screen: AnalyticsEnums.Name.Screen? = nil) {
        let title = String.localized(.error)
        var message = String.localized(.errorUnknown)
        if let error = error, error.code == nil {
            message = String.localized(.errorOffline)
        }
        self.alert(title: title, message: message, buttonTitle: .localized(retry ? .retry : .ok), completion: completion, dialog: AnalyticsEnums.Name.Screen.error, screen: screen)
    }
    
    // Alert with only one button
    func alert(title: String,
               message: String,
               buttonTitle: String,
               completion: (() -> ())? = nil,
               dialog: AnalyticsEnums.Name.Screen? = nil,
               screen: AnalyticsEnums.Name.Screen? = nil)
    {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        if let dialog = dialog { Analytics.trackView(screen: dialog, from: screen) }

        // Submit button
        let button = UIAlertAction(title: buttonTitle, style: .default) {
            _ in
            Analytics.trackClick(button: .okDialog, screen: dialog)
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
               okCompletion: @escaping (() -> ()),
               dialog: AnalyticsEnums.Name.Screen? = nil,
               screen: AnalyticsEnums.Name.Screen? = nil)
    {
        self.alert(title: title, message: message, cancelButtonTitle: cancelButtonTitle, cancelCompletion: nil, okButtonTitle: okButtonTitle, okCompletion: okCompletion, dialog: dialog, screen: screen)
    }
    
    
    // Alert with Ok and Cancel button
    func alert(title: String,
               message: String,
               cancelButtonTitle: String,
               cancelCompletion: (() -> ())?,
               okButtonTitle: String,
               okCompletion: @escaping (() -> ()),
               dialog: AnalyticsEnums.Name.Screen? = nil,
               screen: AnalyticsEnums.Name.Screen? = nil)
    {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)

        if let dialog = dialog { Analytics.trackView(screen: dialog, from: screen) }
        
        // cancel button
        let backAction = UIAlertAction(title: cancelButtonTitle, style: .default) {
            _ in
            Analytics.trackClick(button: .dismissDialog, screen: dialog)
            
            alert.dismiss(animated: true, completion: nil)
            cancelCompletion?()
        }
        
        // OK button
        let submitAction = UIAlertAction(title: okButtonTitle, style: .default) {
            _ in
            Analytics.trackClick(button: .okDialog, screen: dialog)
            alert.dismiss(animated: true, completion: nil)
            okCompletion()
        }
        
        alert.addAction(backAction)
        alert.addAction(submitAction)
        self.present(alert, animated: true, completion: nil)
        
        // number of lines
        UILabel.appearance(whenContainedInInstancesOf: [UIAlertController.self]).numberOfLines = 0
        UILabel.appearance(whenContainedInInstancesOf: [UIAlertController.self]).lineBreakMode = .byWordWrapping
        
    }
    
    func buildAlertDestructive(title: String,
                               message: String,
                               cancelButtonTitle: String,
                               destructiveButtonTitle: String,
                               destructiveCompletion: @escaping (() -> ()),
                               dialog: AnalyticsEnums.Name.Screen? = nil,
                               screen: AnalyticsEnums.Name.Screen? = nil) -> UIAlertController
    {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        if let dialog = dialog { Analytics.trackView(screen: dialog, from: screen) }
        
        // Submit button
        let backAction = UIAlertAction(title: cancelButtonTitle, style: .default) {
            _ in
            Analytics.trackClick(button: .dismissDialog, screen: dialog)
            alert.dismiss(animated: true, completion: nil)
        }
        
        // Delete button
        let deleteAction = UIAlertAction(title: destructiveButtonTitle, style: .destructive) {
            _ in
            Analytics.trackClick(button: .destructiveDialog, screen: dialog)
            alert.dismiss(animated: true, completion: nil)
            destructiveCompletion()
        }
        
        alert.addAction(backAction)
        alert.addAction(deleteAction)
        
        return alert
    }
}
