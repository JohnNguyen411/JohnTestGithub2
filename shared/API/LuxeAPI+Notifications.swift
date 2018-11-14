//
//  LuxeAPI+Notifications.swift
//  voluxe-driver
//
//  Created by Christoph on 11/2/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation

// TODO https://app.asana.com/0/858610969087925/908722711775269/f
// TODO documentation
extension LuxeAPI {

    func inspect(urlResponse: HTTPURLResponse?, apiResponse: RestAPIResponse?) {

        // login required, update required errors
        // these take precidence over update available
        if let code = apiResponse?.asErrorCode() {
            switch code {
                case .E2001, .E2002, .E2003, .E2004, .E3001:
                    let notification = Notification.loginRequired()
                    NotificationCenter.default.post(notification)
                case .E3006:
                    let notification = Notification.updateRequired()
                    NotificationCenter.default.post(notification)
                default:
                    break
            }
        }

        // application update available
        else if let urlResponse = urlResponse, urlResponse.updateAvailable() {
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

        static var loginRequired: Notification.Name {
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

    static func updateRequired(for version: LuxeAPI.Version? = nil) -> Notification {
        var notification = Notification(name: Notification.Name.LuxeAPI.updateRequired)
        if let version = version { notification.userInfo = ["version": version] }
        return notification
    }

    static func loginRequired() -> Notification {
        let notification = Notification(name: Notification.Name.LuxeAPI.loginRequired)
        return notification
    }

    var version: LuxeAPI.Version? {
        return self.userInfo?["version"] as? LuxeAPI.Version
    }
}
