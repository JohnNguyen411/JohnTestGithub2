//
//  PermissionViewController+Notifications.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 5/18/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UserNotifications

extension PermissionViewController {
    
    func requestPushNotifications() {
        weak var weakSelf = self
        UNUserNotificationCenter.current().delegate = appDelegate
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            guard let selfRef = weakSelf else { return }
            Logger.print("Permission granted: \(granted)")
            if granted {
                VLAnalytics.logEventWithName(AnalyticsConstants.eventPermissionNotificationGranted, screenName: selfRef.screenName)
                UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                    Logger.print("Notification settings: \(settings)")
                    guard settings.authorizationStatus == .authorized else { return }
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                        selfRef.dismiss(animated: true)
                    }
                }
            } else {
                VLAnalytics.logEventWithName(AnalyticsConstants.eventPermissionNotificationDenied, screenName: selfRef.screenName)
                selfRef.dismiss(animated: true)
            }
        }
    }
    
}
