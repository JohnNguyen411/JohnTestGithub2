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

    static func getRunConfig() -> String {
        //swiftlint:disable:next force_cast
        let config = Bundle.main.object(forInfoDictionaryKey: "com.volvocars.hse.environment") as! String
        
        return config
    }
    
    private var _appToken: String?
    var appToken: String? {
        set(val) {
            userDefaults.setValue(val, forKey: Constants.AccessTokenKey)
            _appToken = val
        }
        get {
            if _appToken == nil {
                _appToken = userDefaults.value(forKey: Constants.AccessTokenKey) as? String
            }
            return _appToken
        }
    }
    
    fileprivate func createMenuView() {
        
        let mainViewController = MainViewController()
        let leftViewController = LeftViewController()
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        SlideMenuOptions.contentViewScale = 1.0
        SlideMenuOptions.pointOfNoReturnWidth = 0.0
    
        nvc.navigationBar.isTranslucent = false
        nvc.navigationBar.backgroundColor = UIColor("#FFFFFF")
        nvc.navigationBar.tintColor = UIColor("#000000")
        
        leftViewController.mainNavigationViewController = nvc
        leftViewController.mainViewController = mainViewController
        
        let slideMenuController = SlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        slideMenuController.delegate = mainViewController
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
        
        createMenuView()
        /*let homeViewController = FTUEViewController()
        window!.rootViewController = homeViewController
        window!.makeKeyAndVisible()
    */
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

