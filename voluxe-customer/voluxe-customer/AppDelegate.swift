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
import Branch
import ObjectMapper


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
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .notDetermined else { return }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                if UserManager.sharedInstance.getBookings().count > 0 {
                    var requestPermission = false
                    for booking in UserManager.sharedInstance.getBookings() {
                        if booking.isInvalidated || booking.getState() == .canceled || booking.getState() == .completed { continue }
                        if UserDefaults.standard.shouldShowNotifPermissionForBooking(booking: booking) {
                            UserDefaults.standard.showNotifPermissionForBooking(booking: booking, shouldShow: true)
                            requestPermission = true
                            break
                        }
                    }
                    if requestPermission {
                        SwiftEventBus.post("requestNotifPermission")
                    }
                }
            })
        }
    }
    
    fileprivate func createMenuView(animated: Bool) {
        
        let mainViewController = VehiclesViewController(state: .idle)
        let leftViewController = LeftViewController()
        
        mainViewController.view.accessibilityIdentifier = "mainViewController"
        leftViewController.view.accessibilityIdentifier = "leftViewController"
        
        let uiNavigationController = UINavigationController(rootViewController: mainViewController)
        uiNavigationController.view.accessibilityIdentifier = "uiNavigationController"

        styleNavigationBar(navigationBar: uiNavigationController.navigationBar)
        
        navigationController = uiNavigationController
        navigationController?.setTitle(title: .PickupAndDelivery)

        leftViewController.mainNavigationViewController = navigationController
        
        let menuController = VLSlideMenuController(mainViewController: uiNavigationController, leftMenuViewController: leftViewController)
        menuController.automaticallyAdjustsScrollViewInsets = true
        menuController.view.accessibilityIdentifier = "slideMenuController"
        self.slideMenuController = menuController

        // TODO this could be a UIView animation extension
        if let snapShot = self.window?.snapshotView(afterScreenUpdates: true), animated {
            slideMenuController?.view.addSubview(snapShot)
            self.window?.rootViewController = self.slideMenuController
            
            UIView.animate(withDuration: 0.75, animations: {
                snapShot.layer.opacity = 0
                snapShot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
            }, completion: { finished in
                snapShot.removeFromSuperview()
            })
        } else {
            self.window?.rootViewController = self.slideMenuController
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

    // TODO Move view controller management from AppDelegate to AppController
    // https://github.com/volvo-cars/ios/issues/225
    func startApp() {
        
        if let slideMenuController = self.slideMenuController {
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
                var vehicleViewController: BaseViewController?
                if let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: vehicle), booking.bookingFeedbackId > -1, state == .completed {
                    vehicleViewController = BookingRatingViewController(vehicle: vehicle)
                } else {
                    vehicleViewController = MainViewController(vehicle: vehicle, state: state)
                }
                let uiNavigationController = UINavigationController(rootViewController: vehicleViewController!)
                styleNavigationBar(navigationBar: uiNavigationController.navigationBar)
                leftVC.changeMainViewController(uiNavigationController: uiNavigationController, title: nil, animated: true)
            }
        }
    }
    
    func loadBookingFeedback(bookingFeedback: BookingFeedback) {
        showMainView(animated: true)
        // need to delay to make sure the leftpanel is created already
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
            
            if let slideMenu = self.slideMenuController {
                if let leftVC = slideMenu.leftViewController as? LeftViewController {
                    let uiNavigationController = UINavigationController(rootViewController: BookingRatingViewController(bookingFeedback: bookingFeedback))
                    self.styleNavigationBar(navigationBar: uiNavigationController.navigationBar)
                    leftVC.changeMainViewController(uiNavigationController: uiNavigationController, title: nil, animated: true)
                }
            }
        })
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
        let uiNavigationController = UINavigationController(rootViewController: FTUEAddVehicleViewController())
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
        
        SwiftEventBus.onMainThread(self, name: "bookingAdded") {
            notification in
            // if a booking was added and there is only 1 active booking, show that screen
            if UserManager.sharedInstance.getBookings().count > 0 {
                let booking = UserManager.sharedInstance.getBookings()[0]
                if let vehicle = booking.vehicle {
                    self.loadViewForVehicle(vehicle: vehicle, state: ServiceState.appStateForBookingState(bookingState: booking.getState()))
                }
            }
        }
        
        SwiftEventBus.onMainThread(self, name: "bookingRemoved") {
            notification in
            if UserManager.sharedInstance.getBookings().count > 0 {
                let booking = UserManager.sharedInstance.getBookings()[0]
                if let vehicle = booking.vehicle {
                    self.loadViewForVehicle(vehicle: vehicle, state: ServiceState.appStateForBookingState(bookingState: booking.getState()))
                }
            } else {
                // might be in rating state.
            }
        }
    }

    // MARK:- Application support

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = LogoViewController(screenNameEnum: .splash)
        window!.makeKeyAndVisible()
        
        if UserDefaults.standard.enableAlamoFireLogging {
            NetworkActivityLogger.shared.level = .debug
            NetworkActivityLogger.shared.startLogging()
        }

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
        if UserManager.sharedInstance.isLoggedIn() {
            if UserManager.sharedInstance.getBookings().count == 0 {
                BookingSyncManager.sharedInstance.fetchActiveBookings() // force sync now
            } else {
                BookingSyncManager.sharedInstance.syncBookings()
            }
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
    
    private func setupBranch(_ application: UIApplication, launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        
        #if DEBUG
            Branch.setUseTestBranchKey(true)
            Branch.getInstance().setDebug()
        #endif
        
        
        SwiftEventBus.onMainThread(self, name: "channelDealershipSignup") {
            notification in
            UserManager.sharedInstance.logout()
            self.startApp()
        }
        
        // listener for Branch Deep Link data
        Branch.getInstance().initSession(launchOptions: launchOptions) { (params, error) in
            // do stuff with deep link data (nav to page, display content, etc)
            print(params as? [String: AnyObject] ?? {})
            if let params = params as? [String: AnyObject] {
                let deeplinkObject = Mapper<BranchDeeplink>().map(JSON: params)
                DeeplinkManager.sharedInstance.handleDeeplink(deeplinkObject: deeplinkObject)
            }
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        Branch.getInstance().application(app, open: url, options: options)
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
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
            if UserManager.sharedInstance.getBookings().count == 0 {
                BookingSyncManager.sharedInstance.fetchActiveBookings() // force sync now
            } else {
                BookingSyncManager.sharedInstance.syncBookings()
            }
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
            if UserManager.sharedInstance.getBookings().count == 0 {
                BookingSyncManager.sharedInstance.fetchActiveBookings() // force sync now
            } else {
                BookingSyncManager.sharedInstance.syncBookings()
            }
            completionHandler([.alert, .badge, .sound]) // show foreground notifications
        }
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

