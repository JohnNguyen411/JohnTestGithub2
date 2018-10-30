//
//  AppDelegate.swift
//  voluxe-driver
//
//  Created by Christoph on 10/16/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = AppController()
        window.makeKeyAndVisible()
        self.window = window
        return true
    }

    /// Do custom init work here like background fetch, push notifications
    /// and frameworks.
    private func initDidFinishLaunchingWithOptions() {
        self.initBackgroundFetch()
    }
}

