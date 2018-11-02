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
            guard let version = notification.version else { return }
            self?.showUpdateAlert(for: version)
        }

        NotificationCenter.default.addObserver(forName: Notification.Name.LuxeAPI.updateRequired,
                                               object: nil,
                                               queue: nil)
        {
            [weak self] notification in
            guard let version = notification.version else { return }
            self?.showUpdateAlert(for: version, required: true)
        }
    }

    func deregisterAPINotifications() {
        NotificationCenter.default.removeObserver(self)
    }

    // TODO https://app.asana.com/0/858610969087925/894650916838358/f
    // TODO localize
    // Note that there is nothing checking if an alert has already been presented.
    // It's possible the app is showing an OS alert (like notification permissions)
    // but unlikely given a new app install will be the latest version so this
    // alert should not be shown.
    private func showUpdateAlert(for version: LuxeAPI.Version, required: Bool = false) {

        guard version.isKnown else { return }

        let availableMessage = "A new version \(version) is available from the App Store.  Please update as soon as possible."
        let requiredMessage = "A new version \(version) is required from the App Store.  Please update immediately."
        let message = required ? requiredMessage : availableMessage

        let availableTitle = "Update Available"
        let requiredTitle = "Update Required"
        let title = required ? requiredTitle : availableTitle

        let controller = UIAlertController(title: title,
                                           message: message,
                                           preferredStyle: .alert)

        let appStoreAction = UIAlertAction(title: "App Store", style: .default) {
            _ in
            // TODO need app store URL
            // TODO https://app.asana.com/0/858610969087925/894650916838358/f
        }
        controller.addAction(appStoreAction)

        if !required {
            let cancelAction = UIAlertAction(title: "Later", style: .cancel) {
                _ in
                controller.dismiss(animated: true)
            }
            controller.addAction(cancelAction)
        }

        self.present(controller, animated: true)
    }
}
