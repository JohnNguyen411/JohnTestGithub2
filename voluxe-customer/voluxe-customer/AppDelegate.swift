//
//  AppDelegate.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 10/24/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Crashlytics
import Fabric
import Firebase
import GoogleMaps
import GooglePlaces
import SlideMenuControllerSwift
import SwiftEventBus
import UIKit
import UserNotifications
import Branch


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    let gcmMessageIDKey = "gcm.message_id"

    var window: UIWindow?

    var initialized = false
    let userDefaults = UserDefaults.standard
    
    var rootViewController: RootViewController?
    
    private func loadRemoteConfig() {
        RemoteConfigManager.sharedInstance.fetch()
    }
    
    // MARK:- Register network layer notifications

    private func registerEventBusNotifications() {

        SwiftEventBus.onMainThread(self, name: "forceLogout") {
            notification in
            UserManager.sharedInstance.logout()
            AppController.sharedInstance.startApp()
        }

        SwiftEventBus.onMainThread(self, name: "forceUpgrade") {
            notification in
            AppController.sharedInstance.showForceUpgradeDialog()
        }
        
        SwiftEventBus.onMainThread(self, name: "updateAvailable") {
            notification in
            guard let version = notification?.object as? String else { return }
            AppController.sharedInstance.showSoftUpgradeDialog(version: version)
        }
        
        SwiftEventBus.onMainThread(self, name: "bookingAdded") {
            notification in
            // if a booking was added and there is only 1 active booking, show that screen
            if UserManager.sharedInstance.getBookings().count > 0 {
                let booking = UserManager.sharedInstance.getBookings()[0]
                if let vehicle = booking.vehicle {
                    AppController.sharedInstance.loadViewForVehicle(vehicle: vehicle, state: ServiceState.appStateForBookingState(bookingState: booking.getState()))
                }
            }
        }
        
        SwiftEventBus.onMainThread(self, name: "bookingRemoved") {
            notification in
            if UserManager.sharedInstance.getBookings().count > 0 {
                let booking = UserManager.sharedInstance.getBookings()[0]
                if let vehicle = booking.vehicle {
                    AppController.sharedInstance.loadViewForVehicle(vehicle: vehicle, state: ServiceState.appStateForBookingState(bookingState: booking.getState()))
                }
            } else {
                // might be in rating state.
            }
        }
    }

    // MARK:- Application support

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // init API Token
        if let accessToken = KeychainManager.sharedInstance.accessToken, !accessToken.isEmpty {
            CustomerAPI.initToken(token: accessToken)
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        _ = AppController.sharedInstance // init
        
        rootViewController = RootViewController()
        window!.rootViewController = rootViewController
        window!.makeKeyAndVisible()
        
        FontName.family = .volvo
        
        //TODO: figure out logging for AlamoFire5
        /*
        if UserDefaults.standard.enableAlamoFireLogging {
            NetworkActivityLogger.shared.level = .debug
            NetworkActivityLogger.shared.startLogging()
        }
         */

        setupFirebase(application)
        setupBranch(application, launchOptions: launchOptions)

        _ = Logger.init()
        GMSServices.provideAPIKey(Config.sharedInstance.mapAPIKey())
        GMSPlacesClient.provideAPIKey(Config.sharedInstance.mapAPIKey())

        // logoutOnLaunch can be specified as an executable argument
        // Typically and currently this is only used by the UI test suite
        if UIApplication.logoutOnLaunch || UserDefaults.standard.isFirstTimeLaunch {
            UserManager.sharedInstance.logout()
        }

        self.registerEventBusNotifications()

        // Run Realm Migration if needed, then open app
        RealmManager.realmMigration(callback: { realm, error in
            AppController.sharedInstance.startApp()
        })

        // Fabric recommends initializing Crashlytics at the end
        Fabric.with([Crashlytics.self])

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if UserManager.sharedInstance.isLoggedIn() {
            BookingSyncManager.sharedInstance.syncBookings() // force sync now
        }
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK:- Firebase

    private func setupFirebase(_ application: UIApplication) {

        if UserDefaults.standard.disableFirebase == false {
            FirebaseApp.configure()
        }
        
        /* Firebase needs to be enabled for RemoteConfig to work.
         * But we still need to init it if we disable Firebase in order to use the default values provided in RemoteConfigDefaults.plist
         */
        loadRemoteConfig()
        
        // set UserProperties
        Analytics.updateDeviceContext()
        Analytics.updateUserContext()
    }
    
    // MARK:- Branch
    
    private func setupBranch(_ application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        
        #if DEBUG
            Branch.setUseTestBranchKey(true)
            Branch.getInstance().setDebug()
        #endif
        
        
        SwiftEventBus.onMainThread(self, name: "channelDealershipSignup") {
            notification in
            UserManager.sharedInstance.logout()
            AppController.sharedInstance.startApp()
        }
        
        // listener for Branch Deep Link data
        Branch.getInstance().initSession(launchOptions: launchOptions) { (params, error) in
            // do stuff with deep link data (nav to page, display content, etc)
            print(params as? [String: AnyObject] ?? {})
            // TODO: check that Branch decoding is working fine
            if let params = params as? [String: AnyObject], let jsonData = try? JSONSerialization.data(withJSONObject: params, options: []) {
                if let deeplinkObject: BranchDeeplink = BranchDeeplink.decode(data: jsonData) {
                    DeeplinkManager.sharedInstance.handleDeeplink(deeplinkObject: deeplinkObject)
                }
            }
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        Branch.getInstance().application(app, open: url, options: options)
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        // handler for Universal Links
        Branch.getInstance().continue(userActivity)
        return true
    }

    // MARK:- UNUserNotificationCenterDelegate

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
    
    
}

// MARK:- Extensions

extension AppDelegate: VLAlertViewDelegate {
    
    func okButtonTapped() {
        
        if let url = URL(string: "https://itunes.apple.com/us/app/luxe-by-volvo/id1408457126"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func cancelButtonTapped() {
        
    }
}

extension UIApplication {

    public static var isRunningTest: Bool {
        return ProcessInfo().arguments.contains("testMode")
    }
    
    public static var logoutOnLaunch: Bool {
        return ProcessInfo().arguments.contains("logoutOnLaunch")
    }
}

