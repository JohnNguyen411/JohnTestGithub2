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
    
    
    // Return true if we should show the Dialog to update the app
    // The dialog should be shown only once per new version
    func shouldShowUpdateForVersion(_ version: String) -> Bool {
        let currentVersion = Bundle.main.version
        let lastVersion = latestCheckedVersion
        
        // if the install version is newer or equal to new version
        if versionIsNewerOrEqualThan(currentVersion, compareVersion: version) {
            return false
        } else if lastVersion != nil && versionIsNewerOrEqualThan(lastVersion!, compareVersion: version) {
            return false
        } else {
            return true
        }
    }
    
    
    private func versionIsNewerOrEqualThan(_ version: String, compareVersion: String) -> Bool {
        if version.compare(compareVersion, options: .numeric) == .orderedDescending || version.compare(compareVersion, options: .numeric) == .orderedSame {
            return true
        }
        return false
    }
    
    
    // store the Last Checked Version for the Soft Update
    var latestCheckedVersion: String? {
        get {
            return self.string(forKey: #function)
        }
        set {
            self.set(newValue, forKey: #function)
            self.synchronize()
        }
    }
}
