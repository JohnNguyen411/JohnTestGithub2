//
//  AppDelegate+Fetch.swift
//  voluxe-driver
//
//  Created by Christoph on 10/30/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

extension AppDelegate {

    /// This should be called from AppDelegate.application(didFinishLaunching:options).
    func initBackgroundFetch() {
        UIApplication.shared.setMinimumBackgroundFetchInterval(3600)
    }

    func application(_ application: UIApplication,
                     performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        // TODO https://app.asana.com/0/858610969087925/888668564766602/f
        // TODO refresh driver, requests
        // The OS uses the completion handler responses to decide when the
        // app gets woken up, so until we're doing actual work we'll just
        // fake the responses.  Note that this is NOT a substitution for
        // reacting to push notifications, and is complementary to it.
        (arc4random() % 2 == 0) ? completionHandler(.newData) : completionHandler(.noData)
    }
}
