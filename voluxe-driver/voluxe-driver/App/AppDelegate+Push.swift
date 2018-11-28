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

    func initPushNotifications() {
        FirebaseApp.configure()
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

    // TODO temporary to confirm the app is speaking to APNS
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        NSLog("\n\nAPNS TOKEN REGISTERED\n")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {

    // called when notification is interacted with while app is backgrounded
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void)
    {
        guard response.actionIdentifier == UNNotificationDefaultActionIdentifier else { return }
        let content = response.notification.request.content
        NSLog("\n\nPUSH NOTIFICATION: \(content.title) - \(content.body)\n")
        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken token: String) {
        NSLog("\n\nFIREBASE TOKEN: \(token)\n")
        // TODO update driver token
    }
}
