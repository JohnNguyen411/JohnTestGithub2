//
//  UserManager.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 12/6/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import KeychainAccess

final class UserManager {

    static let sharedInstance = UserManager()
    
    private let serviceId: String
    private var accessToken: String?
    private let keychain: Keychain
    
    init() {
        let bundle = Bundle(for: type(of: self))
        serviceId = bundle.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String
        keychain = Keychain(service: serviceId)
        loadAccessToken()
    }
    
    private func loadAccessToken() {
        accessToken = keychain["token"]
    }
    
    private func saveAccessToken(token: String?) {
        keychain["token"] = token
        accessToken = token
    }
    
    public func getAccessToken() -> String? {
        return accessToken
    }
    
    public func loginSuccess(token: String) {
        saveAccessToken(token: token)
    }
    
    public func logout() {
        saveAccessToken(token: nil)
    }
    
}
