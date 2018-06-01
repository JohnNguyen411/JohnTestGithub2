//
//  AppDelegate.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 10/24/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import AlamofireNetworkActivityLogger
import Crashlytics
import Fabric
import Firebase
import GoogleMaps
import GooglePlaces
import SlideMenuControllerSwift
import SwiftEventBus
import UIKit
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    let gcmMessageIDKey = "gcm.message_id"

    var window: UIWindow?

    var initialized = false
    let userDefaults = UserDefaults.standard
    
    var navigationController: UINavigationController?
    var slideMenuController: SlideMenuController?
    
    fileprivate func showLoadingView() {
        //LoadingView Controller is the entry point of the app LoadingViewController
        window!.rootViewController = LoadingViewController()
        window!.makeKeyAndVisible()
    }
    
    func showMainView(animated: Bool) {
        createMenuView(animated: animated)
    }
    
    // showVehiclesView: show VehiclesView if no active services, current service if any
    func showVehiclesView(animated: Bool) {
        showMainView(animated: animated)
        // need to delay to make sure the leftpanel is created already
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
            if UserManager.sharedInstance.getActiveBookings().count > 0 {
                let booking = UserManager.sharedInstance.getActiveBookings()[0]
                if let vehicle = booking.vehicle {
                    self.loadViewForVehicle(vehicle: vehicle, state: StateServiceManager.sharedInstance.getState(vehicleId: vehicle.id))
                }
            }
        })
    }
    
    fileprivate func createMenuView(animated: Bool) {
        
        let mainViewController = VehiclesViewController(state: .idle)
        let leftViewController = LeftViewController()
        
        mainViewController.view.accessibilityIdentifier = "mainViewController"
        leftViewController.view.accessibilityIdentifier = "leftViewController"
        
        let uiNavigationController = UINavigationController(rootViewController: mainViewController)
        uiNavigationController.view.accessibilityIdentifier = "uiNavigationController"
        
        SlideMenuOptions.hideStatusBar = false
        SlideMenuOptions.contentViewScale = 1.0
        SlideMenuOptions.pointOfNoReturnWidth = 0.0
        SlideMenuOptions.shadowOpacity = 0.3
        SlideMenuOptions.shadowRadius = 2.0
        SlideMenuOptions.shadowOffset = CGSize(width: 5, height: 0)
        SlideMenuOptions.contentViewOpacity = 0.3

        styleNavigationBar(navigationBar: uiNavigationController.navigationBar)
        
        navigationController = uiNavigationController
        navigationController?.setTitle(title: .PickupAndDelivery)

        leftViewController.mainNavigationViewController = navigationController
        //leftViewController.mainViewController = mainViewController
        
        let menuController = VLSlideMenuController(mainViewController: uiNavigationController, leftMenuViewController: leftViewController)
        menuController.automaticallyAdjustsScrollViewInsets = true
        menuController.delegate = mainViewController
        
        slideMenuController = menuController
        
        slideMenuController?.view.accessibilityIdentifier = "slideMenuController"

        if let snapShot = self.window?.snapshotView(afterScreenUpdates: true), animated {
            slideMenuController?.view.addSubview(snapShot)
            self.window?.rootViewController = slideMenuController
            
            UIView.animate(withDuration: 0.75, animations: {
                snapShot.layer.opacity = 0
                snapShot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
            }, completion: { finished in
                snapShot.removeFromSuperview()
            })
        } else {
            self.window?.rootViewController = slideMenuController
        }
        
    }
    
    private func loadRemoteConfig() {
        RemoteConfigManager.sharedInstance.fetch()
    }
    
    func showForceUpgradeDialog() {
        if let window = self.window, let rootViewController = window.rootViewController {
            // check if already added
            if let _ = rootViewController.presentedViewController as? VLAlertViewController {
                return
            }
            let alert = VLAlertViewController(title: String.ForceUpgradeTitle, message: String.ForceUpgradeMessage, cancelButtonTitle: nil, okButtonTitle: String.Ok.uppercased())
            alert.delegate = self
            alert.dismissOnTap = false
            
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    func startApp() {
        
        if let slideMenuController = slideMenuController {
            slideMenuController.mainViewController?.dismiss(animated: false, completion: nil)
            slideMenuController.leftViewController?.dismiss(animated: false, completion: nil)
        }
        
        if let window = window, let rootVC = window.rootViewController {
            rootVC.dismiss(animated: false, completion: {})
        }
        
        if window == nil {
            window = UIWindow(frame: UIScreen.main.bounds)
        }
        
        if !UserManager.sharedInstance.isLoggedIn() {
            let uiNavigationController = UINavigationController(rootViewController: FTUEStartViewController())
            styleNavigationBar(navigationBar: uiNavigationController.navigationBar)
            window!.rootViewController = uiNavigationController
            window!.makeKeyAndVisible()
        } else {
            loadMainScreen()
        }
    }
    
    func loadViewForVehicle(vehicle: Vehicle, state: ServiceState) {
        if let slideMenu = slideMenuController {
            if let leftVC = slideMenu.leftViewController as? LeftViewController {
                let uiNavigationController = UINavigationController(rootViewController: MainViewController(vehicle: vehicle, state: state))
                styleNavigationBar(navigationBar: uiNavigationController.navigationBar)
                leftVC.changeMainViewController(uiNavigationController: uiNavigationController, title: nil, animated: true)
            }
        }
    }
    
    func settingsScreen() {
        if let slideMenu = slideMenuController {
            if let leftVC = slideMenu.leftViewController as? LeftViewController {
                let uiNavigationController = UINavigationController(rootViewController: SettingsViewController())
                styleNavigationBar(navigationBar: uiNavigationController.navigationBar)
                leftVC.changeMainViewController(uiNavigationController: uiNavigationController, title: .Settings, animated: true)
            }
        }
    }
    
    func phoneVerificationScreen() {
        if window == nil {
            window = UIWindow(frame: UIScreen.main.bounds)
        }
        let uiNavigationController = UINavigationController(rootViewController: FTUEPhoneVerificationViewController())
        styleNavigationBar(navigationBar: uiNavigationController.navigationBar)
        window!.rootViewController = uiNavigationController
        window!.makeKeyAndVisible()
    }
    
    func showAddVehicleScreen() {
        if window == nil {
            window = UIWindow(frame: UIScreen.main.bounds)
        }
        let uiNavigationController = UINavigationController(rootViewController: FTUEAddVehicleViewController(fromSettings: false))
        styleNavigationBar(navigationBar: uiNavigationController.navigationBar)
        window!.rootViewController = uiNavigationController
        window!.makeKeyAndVisible()
    }
    
    
    private func styleNavigationBar(navigationBar: UINavigationBar) {
        navigationBar.isTranslucent = false
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.tintColor = .luxeCobaltBlue()
        
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
    }

    func loadMainScreen() {
        showLoadingView()
    }

    // MARK:- Register network layer notifications

    private func registerEventBusNotifications() {

        SwiftEventBus.onMainThread(self, name: "forceLogout") {
            notification in
            UserManager.sharedInstance.logout()
            self.startApp()
        }

        SwiftEventBus.onMainThread(self, name: "forceUpgrade") {
            notification in
            self.showForceUpgradeDialog()
        }
    }

    // MARK:- Application support

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = LogoViewController(screenName: AnalyticsConstants.paramNameSplashScreenView)
        window!.makeKeyAndVisible()
        
        if UserDefaults.standard.enableAlamoFireLogging {
            NetworkActivityLogger.shared.level = .debug
            NetworkActivityLogger.shared.startLogging()
        }

        setupFirebase(application)

        _ = Logger.init()
        GMSServices.provideAPIKey(Config.sharedInstance.mapAPIKey())
        GMSPlacesClient.provideAPIKey(Config.sharedInstance.mapAPIKey())

        // logoutOnLaunch can be specified as an executable argument
        // Typically and currently this is only used by the UI test suite
        if UIApplication.logoutOnLaunch {
            UserManager.sharedInstance.logout()
        }

        self.registerEventBusNotifications()

        weak var weakSelf = self
        // Run Realm Migration if needed, then open app
        RealmManager.realmMigration(callback: { realm, error in
            weakSelf?.startApp()
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
        Analytics.setUserProperty(UIDevice.current.identifierForVendor?.uuidString, forName: AnalyticsConstants.userPropertiesDeviceId)
        
        if let customerId = UserManager.sharedInstance.customerId() {
            Analytics.setUserProperty(String(customerId), forName: AnalyticsConstants.userPropertiesCustomerId)
        } else {
            Analytics.setUserProperty(nil, forName: AnalyticsConstants.userPropertiesCustomerId)
        }

    }

    // MARK:- UNUserNotificationCenterDelegate

    // This is called when the user interacts with specific options on a notification
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void)
    {
        BookingSyncManager.sharedInstance.syncBookings() // force sync now
        completionHandler()
    }

    // This is called when a message is received in the foreground
    // or when a notification is tapped on when app is in background
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        BookingSyncManager.sharedInstance.syncBookings() // force sync now
        completionHandler([.alert, .badge, .sound]) // show foreground notifications
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        KeychainManager.sharedInstance.pushDeviceToken = token
        // registerDevice for push notification if deviceToken Stored
        if let customerId = UserManager.sharedInstance.customerId() {
            CustomerAPI().registerDevice(customerId: customerId, deviceToken: token).onSuccess { result in
                }.onFailure { error in
            }
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        if let customerId = UserManager.sharedInstance.customerId() {
            // unregister device
            CustomerAPI().registerDevice(customerId: customerId, deviceToken: "").onSuccess { result in
                }.onFailure { error in
            }
        }
    }
    
   
    func registerForPushNotifications() {
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == .notDetermined {
                // request
                let permissionController = PermissionViewController(permissionType: .notification, completion: {})
                self.window?.rootViewController?.definesPresentationContext = true
                self.window?.rootViewController?.present(permissionController, animated: true, completion: nil)
            } else {
                guard settings.authorizationStatus == .authorized else { return }
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    
}

// MARK:- Extensions

extension AppDelegate: VLAlertViewDelegate {
    
    func okButtonTapped() {
        
        //TODO: Update Link App
        // https://github.com/volvo-cars/ios/issues/133
        if let url = URL(string: "http://itunes.apple.com/app/idXXXXXXXXX"), UIApplication.shared.canOpenURL(url) {
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

