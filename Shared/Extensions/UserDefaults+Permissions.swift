//
//  UserDefaults+Permissions.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 2/13/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    var hasAskedLocationPermission: Bool {
        get {
            return self.bool(forKey: #function)
        }
        set {
            self.set(newValue, forKey: #function)
        }
    }
    
    var hasAskedPushPermission: Bool {
        get {
            return self.bool(forKey: #function)
        }
        set {
            self.set(newValue, forKey: #function)
        }
    }
    
    
}

