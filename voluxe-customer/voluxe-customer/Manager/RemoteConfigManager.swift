//
//  RemoteConfigManager.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 5/4/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig

final class RemoteConfigManager {
    
    public static let selfPickupEnabledKey = "self_pickup_enabled"
    public static let selfOBEnabledKey = "customer_self_OB_enabled"
    public static let snappedPointsKey = "customer_ios_snapped_points_enabled"
    public static let loanerFeatureEnabledKey = "loaner_feature_enabled"

    static let sharedInstance = RemoteConfigManager()
    private let remoteConfig: RemoteConfig
    private var developerModeEnabled = false
    
    init() {
        #if DEBUG
            developerModeEnabled = true
        #endif
        
        remoteConfig = RemoteConfig.remoteConfig()
        let remoteConfigSettings = RemoteConfigSettings(developerModeEnabled: developerModeEnabled)
        remoteConfig.configSettings = remoteConfigSettings
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
    }
    
    func fetch() {
        var timeInterval = TimeInterval(43200) // default (12 hours)
        
        if developerModeEnabled {
            timeInterval = TimeInterval(5) // 5 sec in debug to test refresh in debug mode
        }
        
        remoteConfig.fetch(withExpirationDuration: timeInterval, completionHandler: { (status, error) -> Void in
            if status == .success {
                Logger.print("Config fetched!")
                self.remoteConfig.activateFetched()
            } else {
                Logger.print("Config not fetched")
                Logger.print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        })
    }
    
    func getStringValue(key: String) -> String? {
        if let stringValue = remoteConfig[key].stringValue {
            return stringValue
        }
        return nil
    }
    
    func getBoolValue(key: String) -> Bool {
        return remoteConfig[key].boolValue
    }
    
}
