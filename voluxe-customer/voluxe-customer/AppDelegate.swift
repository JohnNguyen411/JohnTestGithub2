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
import FirebaseMessaging
import GoogleMaps
import SlideMenuControllerSwift
import UIKit
import UserNotifications
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    let gcmMessageIDKey = "gcm.message_id"

    var window: UIWindow?

    var initialized = false
    let userDefaults = UserDefaults.standard
    
    var navigationController: UINavigationController?
    var slideMenuController: SlideMenuController?

    private static var navigationBarHeight: CGFloat = 0

    
    static func getNavigationBarHeight() -> CGFloat {
        return AppDelegate.navigationBarHeight
    }
    
    
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
        
        SlideMenuOptions.contentViewScale = 1.0
        SlideMenuOptions.pointOfNoReturnWidth = 0.0
    
        styleNavigationBar(navigationBar: uiNavigationController.navigationBar)
        
        navigationController = uiNavigationController
        navigationController?.setTitle(title: UserManager.sharedInstance.yourVolvoStringTitle())

        leftViewController.mainNavigationViewController = navigationController
        //leftViewController.mainViewController = mainViewController
        
        let menuController = VLSlideMenuController(mainViewController: uiNavigationController, leftMenuViewController: leftViewController)
        menuController.automaticallyAdjustsScrollViewInsets = true
        menuController.delegate = mainViewController
        menuController.opacityView.removeFromSuperview()
        
        slideMenuController = menuController
        
        if let navigationController = self.navigationController {
            AppDelegate.navigationBarHeight = navigationController.navigationBar.frame.size.height
        }
        
        slideMenuController?.view.accessibilityIdentifier = "slideMenuController"

        if let snapShot = self.window?.snapshotView(afterScreenUpdates: true), animated {
            slideMenuController?.view.addSubview(snapShot)
            self.window?.rootViewController = slideMenuController
            
            UIView.animate(withDuration: 0.3, animations: {
                snapShot.layer.opacity = 0
                snapShot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
            }, completion: { finished in
                snapShot.removeFromSuperview()
            })
        } else {
            self.window?.rootViewController = slideMenuController
        }
        
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        if UserDefaults.standard.enableAlamoFireLogging {
            NetworkActivityLogger.shared.level = .debug
            NetworkActivityLogger.shared.startLogging()
        }
        
        setupFirebase(application)
        
        _ = Logger.init()
        GMSServices.provideAPIKey(Bundle.main.object(forInfoDictionaryKey: "GoogleMapsAPIKey") as! String)
        GMSPlacesClient.provideAPIKey(Bundle.main.object(forInfoDictionaryKey: "GooglePlacesAPIKey") as! String)

        Fabric.with([Crashlytics.self])

        startApp()
        
        return true
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
        
        if UIApplication.shouldReset {
            UserManager.sharedInstance.logout()
        }
        
        if let slideMenuController = slideMenuController {
            slideMenuController.mainViewController?.dismiss(animated: false, completion: nil)
            slideMenuController.leftViewController?.dismiss(animated: false, completion: nil)
        }
        
        if let window = window, let rootVC = window.rootViewController {
            rootVC.dismiss(animated: false, completion: {})
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        if UserManager.sharedInstance.getAccessToken() == nil {
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
        window = UIWindow(frame: UIScreen.main.bounds)
        let uiNavigationController = UINavigationController(rootViewController: FTUEPhoneVerificationViewController())
        styleNavigationBar(navigationBar: uiNavigationController.navigationBar)
        window!.rootViewController = uiNavigationController
        window!.makeKeyAndVisible()
    }
    
    func showAddVehicleScreen() {
        window = UIWindow(frame: UIScreen.main.bounds)
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
    
    private func setupFirebase(_ application: UIApplication) {

        if UserDefaults.standard.disableFirebase == false {
            FirebaseApp.configure()
        }

        // uncomment for Push Notification
        /*
        if #available(iOS 10.0, *) {
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
         */
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

    func loadMainScreen() {
        showLoadingView()
    }
    
    //MARK: UNUserNotificationCenterDelegate
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        Logger.print("didReceive")
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        Logger.print("willPresent")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            Logger.print("Message ID: \(messageID)")
        }
        
        // Print full message.
        Logger.print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            Logger.print("Message ID: \(messageID)")
        }
        
        // Print full message.
        Logger.print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }

    
    //MARK: MessagingDelegate
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        let token = Messaging.messaging().fcmToken
        Logger.print("FCM token: \(token ?? "")")
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}

extension AppDelegate: VLAlertViewDelegate {
    
    func okButtonTapped() {
        if let url = URL(string: "http://itunes.apple.com/app/idXXXXXXXXX"), UIApplication.shared.canOpenURL(url) {
            // Attempt to open the URL.
            UIApplication.shared.openURL(url)
        }
    }
    
    func cancelButtonTapped() {
        
    }
    
    
    
}

extension UIApplication {
    public static var isRunningTest: Bool {
        return ProcessInfo().arguments.contains("testMode")
    }
    
    public static var shouldReset: Bool {
        return ProcessInfo().arguments.contains("reset")
    }
    
    class func appBuild() -> Int {
        let appBuild = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
        return Int(appBuild)!
    }
}

