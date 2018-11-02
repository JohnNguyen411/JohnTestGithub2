//
//  LuxeAPI+Notifications.swift
//  voluxe-driver
//
//  Created by Christoph on 11/2/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation

extension LuxeAPI {

    @available(*, deprecated)
    enum Notifications: String {

        case updateAvailable = "LuxeAPI.Notifications.updateAvailable"
        case updateRequired = "LuxeAPI.Notifications.updateRequired"

        var name: Notification.Name {
            return Notification.Name(rawValue: self.rawValue)
        }

        func notification() -> Notification {
            let notification = Notification(name: self.name, object: nil)
            return notification
        }

        func notification(with version: LuxeAPI.Version) -> Notification {
            var notification = self.notification()
            notification.userInfo = ["version": version]
            return notification
        }
    }

    func inspect(urlResponse: HTTPURLResponse?, apiResponse: RestAPIResponse?) {

        // TODO application update required

        // application update available
        if let urlResponse = urlResponse, urlResponse.updateAvailable() {
            let version = urlResponse.applicationVersion()
            if UserDefaults.standard.shouldShowUpdate(for: version) {
                let notification = Notification.updateAvailable(for: version)
                NotificationCenter.default.post(notification)
            }
        }
    }
}

extension Notification.Name {

    struct LuxeAPI {

        static var updateAvailable: Notification.Name {
            return Notification.Name("Notification.LuxeAPI.\(#function)")
        }

        static var updateRequired: Notification.Name {
            return Notification.Name("Notification.LuxeAPI.\(#function)")
        }
    }
}

extension Notification {

    static func updateAvailable(for version: LuxeAPI.Version) -> Notification {
        var notification = Notification(name: Notification.Name.LuxeAPI.updateAvailable)
        notification.userInfo = ["version": version]
        return notification
    }

    static func updateRequired(for version: LuxeAPI.Version) -> Notification {
        var notification = Notification(name: Notification.Name.LuxeAPI.updateRequired)
        notification.userInfo = ["version": version]
        return notification
    }

    var version: LuxeAPI.Version? {
        return self.userInfo?["version"] as? LuxeAPI.Version
    }
}
