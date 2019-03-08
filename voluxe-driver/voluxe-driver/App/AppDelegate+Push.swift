//
//  AppDelegate+Push.swift
//  voluxe-driver
//
//  Created by Christoph on 10/30/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//
import Foundation
import UIKit
import UserNotifications

extension AppDelegate {

    /*
    // This is called when the user interacts with specific options on a notification
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void)
    {
        if UserManager.sharedInstance.isLoggedIn() {
            BookingSyncManager.sharedInstance.syncBookings() // force sync now
            completionHandler()
        }
    }
    
    // This is called when a message is received in the foreground
    // or when a notification is tapped on when app is in background
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        if UserManager.sharedInstance.isLoggedIn() {
            BookingSyncManager.sharedInstance.syncBookings() // force sync now
            completionHandler([.alert, .badge, .sound]) // show foreground notifications
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        KeychainManager.sharedInstance.pushDeviceToken = token
        // registerDevice for push notification if deviceToken Stored
        var uuid = ""
        if let deviceId = KeychainManager.sharedInstance.deviceId {
            uuid = deviceId
        }
        
        if let customerId = UserManager.sharedInstance.customerId() {
            CustomerAPI.registerDevice(customerId: customerId, deviceToken: token, deviceId: uuid)
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {}
    
    
    func registerForPushNotificationsIfGranted() {
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    */
    
    // Note that FBAnalytics.configure() should be called before this
    // to ensure that Firebase is initialized.
    func initPushNotifications() {
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
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        OSLog.info("APNS TOKEN REGISTERED: \(token)")
        DriverManager.shared.set(push: token)

    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {

    // This is called when the user interacts with specific options on a notification
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void)
    {
        guard response.actionIdentifier == UNNotificationDefaultActionIdentifier else { return }
        if KeychainManager.shared.getToken() != nil {
            completionHandler()
        }
    }
    
    // This is called when a message is received in the foreground
    // or when a notification is tapped on when app is in background
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        if KeychainManager.shared.getToken() != nil {
            completionHandler([.alert, .badge, .sound]) // show foreground notifications
        }
    }
    
}
