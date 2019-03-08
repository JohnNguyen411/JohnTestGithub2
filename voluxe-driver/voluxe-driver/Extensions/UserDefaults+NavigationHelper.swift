//
//  UserDefaults+NavigationHelper.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 2/14/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    var preferredGPSProvider: String? {
        get {
            return self.string(forKey: #function)
        }
        set {
            self.set(newValue, forKey: #function)
            self.synchronize()
            
            let notification = Notification.providerChanged()
            NotificationCenter.default.post(notification)
        }
    }
    
}
