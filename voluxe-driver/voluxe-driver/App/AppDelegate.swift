//
//  AppDelegate.swift
//  voluxe-driver
//
//  Created by Christoph on 10/16/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Crashlytics
import Fabric
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = AppController.shared
        window.makeKeyAndVisible()
        self.window = window
        self.initServices()
        AppController.shared.launch()
        return true
    }

    /// Do custom init work here like background fetch, push notifications
    /// and frameworks.
    private func initServices() {
        Fabric.with([Crashlytics.self])
        self.initBackgroundFetch()
        self.initLocationUpdates()
        self.initPushNotifications()
        self.initRealm()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        AppController.shared.resume()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        AppController.shared.suspend()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        AppController.shared.exit()
    }
}
