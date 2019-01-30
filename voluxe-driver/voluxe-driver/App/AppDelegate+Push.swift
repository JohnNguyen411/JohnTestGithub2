//
//  AppDelegate+Push.swift
//  voluxe-driver
//
//  Created by Christoph on 10/30/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Firebase
import Foundation
import UserNotifications

extension AppDelegate {

    // Note that FBAnalytics.configure() should be called before this
    // to ensure that Firebase is initialized.
    func initPushNotifications() {
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
    }

    func registerForPushNotifications(completion: ((Bool) -> Void)? = nil) {
        Thread.assertIsMainThread()
        UNUserNotificationCenter.current().getNotificationSettings() {
            [weak self] settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                    case .authorized: UIApplication.shared.registerForRemoteNotifications(); completion?(true)
                    default: self?.requestPushNotifications(completion: completion)
                }
            }
        }
    }

    private func requestPushNotifications(completion: ((Bool) -> Void)? = nil) {
        Thread.assertIsMainThread()
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) {
            allowed, error in
            DispatchQueue.main.async {
                if allowed { UIApplication.shared.registerForRemoteNotifications() }
                completion?(allowed)
            }
        }
    }

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        let string = String(data: deviceToken, encoding: .utf8) ?? "invalid token"
        Log.info("APNS TOKEN REGISTERED: \(string)")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {

    // called when notification is interacted with while app is backgrounded
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void)
    {
        guard response.actionIdentifier == UNNotificationDefaultActionIdentifier else { return }
        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken token: String) {
        DriverManager.shared.set(push: token)
    }
}
