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
    }

    func deregisterAPINotifications() {
        NotificationCenter.default.removeObserver(self)
    }

    // Note that there is nothing checking if an alert has already been presented.
    // It's possible the app is showing an OS alert (like notification permissions)
    // but unlikely given a new app install will be the latest version so this
    // alert should not be shown.
    private func showUpdateAlert(for version: LuxeAPI.Version?, required: Bool = false) {

        let availableMessage = Localized.updateAvailableText
        let requiredMessage = Localized.updateRequiredText
        let message = required ? requiredMessage : availableMessage

        let availableTitle = Localized.updateAvailable
        let requiredTitle = Localized.updateRequired
        let title = required ? requiredTitle : availableTitle

        let controller = UIAlertController(title: title,
                                           message: message,
                                           preferredStyle: .alert)

        let appStoreAction = UIAlertAction(title: Localized.appStore, style: .default) {
            _ in
            // TODO https://app.asana.com/0/858610969087925/894650916838358/f
            // TODO need app store URL
        }
        controller.addAction(appStoreAction)

        if !required {
            let cancelAction = UIAlertAction(title: Localized.later, style: .cancel) {
                _ in
                controller.dismiss(animated: true)
            }
            controller.addAction(cancelAction)
        }

        self.present(controller, animated: true)
    }

    private func showLoginRequiredAlert() {

        let controller = UIAlertController(title: Localized.signInRequired,
                                           message: Localized.signInRequiredText,
                                           preferredStyle: .alert)

        let action = UIAlertAction(title: Localized.signIn, style: .default) {
            action in
            AppController.shared.logout()
        }

        controller.addAction(action)
        self.present(controller, animated: true, completion: nil)
    }
    
    private func showPhoneVerificationController() {

        RequestManager.shared.stop()
        
        guard let driver = DriverManager.shared.driver else {
            AppController.shared.logout()
            return
        }
        
        let steps = FlowViewController.loginSteps(for: driver)
        
        if steps.count == 0 {
            AppController.shared.logout()
        } else {
            AppController.shared.mainController(push: FlowViewController(steps: steps, direction: .horizontal),
                                                asRootViewController: true,
                                                prefersProfileButton: false)
        }
    }
}
