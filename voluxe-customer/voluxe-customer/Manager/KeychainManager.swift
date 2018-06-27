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
    
    private static let accessTokenKey = "token"
    private static let deviceUUIDKey = "deviceUUID"
    private static let deviceTokenKey = "deviceToken"
    private static let customerIdKey = "customerId"

    static let sharedInstance = KeychainManager()
    
    private let serviceId: String
    private let keychain: Keychain
    
    private(set) var customerId: Int?
    private(set) var accessToken: String?

    var deviceId: String? {
        set(newUUID) {
            keychain[KeychainManager.deviceUUIDKey] = newUUID
        }
        get {
            return keychain[KeychainManager.deviceUUIDKey]
        }
    }
    
    var pushDeviceToken: String? {
        set(newToken) {
            keychain[KeychainManager.deviceTokenKey] = newToken
        }
        get {
            return keychain[KeychainManager.deviceTokenKey]
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
        accessToken = keychain[KeychainManager.accessTokenKey]
        NetworkRequest.setAccessToken(accessToken)
        if let customerIdString = keychain[KeychainManager.customerIdKey] {
            self.customerId = Int(customerIdString)
        } else {
            self.customerId = nil
        }
    }
    
    public func saveAccessToken(token: String?, customerId: String?) {
        accessToken = token
        keychain[KeychainManager.accessTokenKey] = token
        keychain[KeychainManager.customerIdKey] = customerId
        if let customerId = customerId {
            self.customerId = Int(customerId)
        } else {
            self.customerId = nil
        }
        NetworkRequest.setAccessToken(token)
        Analytics.updateUserContext()
    }
    
    private func generateUUID() -> String {
        if let deviceID = UIDevice.current.identifierForVendor?.uuidString {
            return deviceID
        }
        return UUID().uuidString
    }
}
