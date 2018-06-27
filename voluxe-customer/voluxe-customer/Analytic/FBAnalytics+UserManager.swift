//
//  FBAnalytics+UserManager.swift
//  voluxe-customer
//
//  Created by Christoph on 6/26/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import FirebaseAnalytics
import Foundation

/// Convenience functions to update the customer and device properties
/// in Firebase.  This is provided here rather than being spread across
/// the code.  Since it relies on state from singletons, there are no
/// arguments.
extension FBAnalytics {

    func updateUserContext() {
        var idString: String?
        if let id = UserManager.sharedInstance.customerId() { idString = String(id) }
        FirebaseAnalytics.Analytics.setUserProperty(idString, forName: "customer_id")
    }

    func updateDeviceContext() {
        FirebaseAnalytics.Analytics.setUserProperty(UIDevice.current.identifierForVendor?.uuidString, forName: "device_id")
    }
}
