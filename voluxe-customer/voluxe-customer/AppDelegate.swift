//
//  AppDelegate.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 10/24/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var initialized = false
    let userDefaults = UserDefaults.standard
    
    var navigationController: UINavigationController?
    var slideMenuController: SlideMenuController?

    private static var navigationBarHeight: CGFloat = 0

    
    static func getNavigationBarHeight() -> CGFloat {
        return AppDelegate.navigationBarHeight
    }
    
    
    fileprivate func createMenuView() {
        
        let mainViewController = MainViewController()
        let leftViewController = LeftViewController()
        
        mainViewController.view.accessibilityIdentifier = "mainViewController"
        leftViewController.view.accessibilityIdentifier = "leftViewController"
        
        let uiNavigationController = UINavigationController(rootViewController: mainViewController)
        uiNavigationController.view.accessibilityIdentifier = "uiNavigationController"
        
        SlideMenuOptions.contentViewScale = 1.0
        SlideMenuOptions.pointOfNoReturnWidth = 0.0
    
        uiNavigationController.navigationBar.isTranslucent = false
        uiNavigationController.navigationBar.backgroundColor = UIColor("#FFFFFF")
        uiNavigationController.navigationBar.tintColor = UIColor("#000000")
        
        leftViewController.mainNavigationViewController = navigationController
        leftViewController.mainViewController = mainViewController
        
        let menuController = SlideMenuController(mainViewController: uiNavigationController, leftMenuViewController: leftViewController)
        menuController.automaticallyAdjustsScrollViewInsets = true
        menuController.delegate = mainViewController
        menuController.opacityView.removeFromSuperview()
        
        slideMenuController = menuController
        navigationController = uiNavigationController
        
        if let navigationController = self.navigationController {
            AppDelegate.navigationBarHeight = navigationController.navigationBar.frame.size.height
        }
        
        slideMenuController?.view.accessibilityIdentifier = "slideMenuController"
        
        // self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GMSServices.provideAPIKey(Bundle.main.object(forInfoDictionaryKey: "GoogleMapsAPIKey") as! String)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        /*
        for familyName in UIFont.familyNames {
            for font in UIFont.fontNames(forFamilyName: familyName) {
                print("font: \(font)")
            }
        }
 */
        
        if UserManager.sharedInstance.getAccessToken() == nil {
            let homeViewController = FTUEViewController()
            window!.rootViewController = homeViewController
            window!.makeKeyAndVisible()
        } else {
            createMenuView()
        }
        
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

    func loadMainScreen() {
        createMenuView()
    }

}

extension UIApplication {
    public static var isRunningTest: Bool {
        return ProcessInfo().arguments.contains("testMode")
    }
}

