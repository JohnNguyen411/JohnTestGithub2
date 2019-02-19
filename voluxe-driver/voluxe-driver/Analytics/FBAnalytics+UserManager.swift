//
//  FBAnalytics+UserManager.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 2/18/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import FirebaseAnalytics
import UIKit
import CoreLocation

/// Convenience functions to update the user and device properties
/// in Firebase.  This is provided here rather than being spread across
/// the code.  Since it relies on state from singletons, there are no
/// arguments.
extension FBAnalytics {
    
    func updateUserContext() {
        var idString: String?
        if let id = DriverManager.shared.driver?.id{ idString = String(id) }
        FirebaseAnalytics.Analytics.setUserProperty(idString, forName: "driver_id")
    }
    
    func updateDeviceContext() {
        FirebaseAnalytics.Analytics.setUserProperty(KeychainManager.shared.deviceId, forName: "device_id")
    }
    
    func updateDriverLocation(location: CLLocation?) {
        if let location = location {
            FirebaseAnalytics.Analytics.setUserProperty("\(location.coordinate.latitude)", forName: "location_latitude")
            FirebaseAnalytics.Analytics.setUserProperty("\(location.coordinate.longitude)", forName: "location_longitude")
            FirebaseAnalytics.Analytics.setUserProperty("\(location.horizontalAccuracy)", forName: "location_accuracy")

        } else {
            FirebaseAnalytics.Analytics.setUserProperty(nil, forName: "location_latitude")
            FirebaseAnalytics.Analytics.setUserProperty(nil, forName: "location_longitude")
            FirebaseAnalytics.Analytics.setUserProperty(nil, forName: "location_accuracy")
        }

    }
}
