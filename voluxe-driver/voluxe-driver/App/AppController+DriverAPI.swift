//
//  AppController+DriverAPI.swift
//  voluxe-driver
//
//  Created by Christoph on 11/1/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import NotificationCenter
import UIKit

extension AppController {

    func registerAPINotifications() {

        NotificationCenter.default.addObserver(forName: Notification.Name.LuxeAPI.updateAvailable,
                                               object: nil,
                                               queue: nil)
        {
            [weak self] notification in
            self?.showUpdateAlert(for: notification.version)
        }

        NotificationCenter.default.addObserver(forName: Notification.Name.LuxeAPI.updateRequired,
                                               object: nil,
                                               queue: nil)
        {
            [weak self] notification in
            self?.showUpdateAlert(for: notification.version, required: true)
        }

        NotificationCenter.default.addObserver(forName: Notification.Name.LuxeAPI.loginRequired,
                                               object: nil,
                                               queue: nil)
        {
            [weak self] notification in
            self?.showLoginRequiredAlert()
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name.LuxeAPI.phoneVerificationRequired,
                                               object: nil,
                                               queue: nil)
        {
            [weak self] notification in
            self?.showPhoneVerificationController()
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name.LuxeAPI.resetPasswordRequired,
                                               object: nil,
                                               queue: nil)
        {
            [weak self] notification in
            self?.showPhoneVerificationController()
        }
    }

    func deregisterAPINotifications() {
        NotificationCenter.default.removeObserver(self)
    }

    // Note that there is nothing checking if an alert has already been presented.
    // It's possible the app is showing an OS alert (like notification permissions)
    // but unlikely given a new app install will be the latest version so this
    // alert should not be shown.
    private func showUpdateAlert(for version: LuxeAPI.Version?, required: Bool = false) {

        let availableMessage = Unlocalized.updateAvailableText
        let requiredMessage = Unlocalized.updateRequiredText
        let message = required ? requiredMessage : availableMessage

        let availableTitle = Unlocalized.updateAvailable
        let requiredTitle = Unlocalized.updateRequired
        let title = required ? requiredTitle : availableTitle

        let controller = UIAlertController(title: title,
                                           message: message,
                                           preferredStyle: .alert)

        let appStoreAction = UIAlertAction(title: Unlocalized.appStore, style: .default) {
            _ in
            // 1408457126 cust
            // 1454728573 agent
            // https://itunes.apple.com/us/app/luxe-by-volvo/id1408457126
            if let url = URL(string: "http://itunes.apple.com/app/id1454728573"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
            
        }
        controller.addAction(appStoreAction)

        if !required {
            let cancelAction = UIAlertAction(title: Unlocalized.later, style: .cancel) {
                _ in
                controller.dismiss(animated: true)
            }
            controller.addAction(cancelAction)
        }

        self.present(controller, animated: true)
    }

    private func showLoginRequiredAlert() {

        let controller = UIAlertController(title: Unlocalized.signInRequired,
                                           message: Unlocalized.signInRequiredText,
                                           preferredStyle: .alert)

        let action = UIAlertAction(title: Unlocalized.signIn, style: .default) {
            action in
            AppController.shared.logout()
        }

        controller.addAction(action)
        self.present(controller, animated: true, completion: nil)
    }
    
    private func showPhoneVerificationController() {

        RequestManager.shared.stop()
        DriverManager.shared.stopLocationUpdates()
        
        guard let driver = DriverManager.shared.driver else {
            AppController.shared.logout()
            return
        }
        
        if AppController.shared.isVerifyingPhoneNumber { return }
        
        // don't show if already showing
        if let presentedController = AppController.shared.presentedController, (((presentedController as? LoginFlowViewController) != nil) || ((presentedController.children.first as? LoginFlowViewController) != nil)) {
            return
        }
        
        var steps = LoginFlowViewController.loginSteps(for: driver)
        
        if steps.count == 0 {
            steps = [PhoneNumberStep(), Step(title: Unlocalized.confirmPhoneNumber, controllerName: PhoneVerificationViewController.className)]
        }

        DriverManager.shared.workPhoneNumberVerified = false
        AppController.shared.isVerifyingPhoneNumber = true
        AppController.shared.mainController(push: LoginFlowViewController(steps: steps, direction: .horizontal),
                                            asRootViewController: true,
                                            prefersProfileButton: false)
    }
}
