//
//  UserDefaults+Debug.swift
//  voluxe-customer
//
//  Created by Christoph on 5/2/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

extension UserDefaults {

    /// Indicates if Firebase is to be disabled on next launch.
    /// By default it is always enabled and can only be changed
    /// in DEBUG builds.
    var disableFirebase: Bool {
        get {
            #if DEBUG
                return self.bool(forKey: #function)
            #else
                return false
            #endif
        }
        set {
            self.set(newValue, forKey: #function)
            self.synchronize()
        }
    }

    /// Indicates if AlamoFire is allowed to output to the console.
    /// Note that this only stores the user's preference but does
    /// not reconfigure the NetworkActivityLogger, the debug settings
    /// view controller manages that.
    var enableAlamoFireLogging: Bool {
        get {
            #if DEBUG
                return self.bool(forKey: #function)
            #else
                return false
            #endif
        }
        set {
            self.set(newValue, forKey: #function)
            self.synchronize()
        }
    }
}
