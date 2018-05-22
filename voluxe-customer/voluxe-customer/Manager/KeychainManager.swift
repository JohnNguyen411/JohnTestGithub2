//
//  KeychainManager.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 5/22/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import KeychainAccess
import FirebaseAnalytics
    
final class KeychainManager {
    
    static let sharedInstance = KeychainManager()
    
    private let serviceId: String
    private let keychain: Keychain
    
    var customerId: Int?
    
    var deviceId: String? {
        set(newUUID) {
            keychain["deviceUUID"] = newUUID
        }
        get {
            return keychain["deviceUUID"]
        }
    }
    
    var pushDeviceToken: String? {
        set(newToken) {
            keychain["deviceToken"] = newToken
        }
        get {
            return keychain["deviceToken"]
        }
    }
    
    init() {
        let bundle = Bundle(for: type(of: self))
        serviceId = bundle.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String
        keychain = Keychain(service: serviceId)
        loadAccessToken()
        loadDeviceId()
    }
    
    private func loadDeviceId() {
        guard let _ = deviceId else {
            deviceId = generateUUID()
            return
        }
    }
    
    private func loadAccessToken() {
        NetworkRequest.accessToken = keychain["token"]
        if let customerIdString = keychain["customerId"] {
            self.customerId = Int(customerIdString)
        } else {
            self.customerId = nil
        }
    }
    
    public func saveAccessToken(token: String?, customerId: String?) {
        keychain["token"] = token
        keychain["customerId"] = customerId
        if let customerId = customerId {
            self.customerId = Int(customerId)
        } else {
            self.customerId = nil
        }
        NetworkRequest.accessToken = token
        
        Analytics.setUserProperty(customerId, forName: AnalyticsConstants.userPropertiesCustomerId)
    }
    
    private func generateUUID() -> String {
        if let deviceID = UIDevice.current.identifierForVendor?.uuidString {
            return deviceID
        }
        return UUID().uuidString
    }
}
