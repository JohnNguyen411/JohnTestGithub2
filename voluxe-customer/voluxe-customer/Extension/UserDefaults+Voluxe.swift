//
//  UserDefaults+Voluxe.swift
//  voluxe-customer
//
//  Created by Christoph on 6/27/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

extension UserDefaults {

    /// Indicates if this is the first time an app has launched.
    /// If there is no value for "isFirstTimeLaunch" then this
    /// will be true.  If set with any value, true or false, then
    /// this will be false.  Reading this value once will cause
    /// it to return false for every subsequence call until the
    /// defaults are deleted (when an app is deleted).
    var isFirstTimeLaunch: Bool {
        get {
            if let _ = self.value(forKey: #function) { return false }
            self.set(false, forKey: #function)
            return true
        }
    }
}
