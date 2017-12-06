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
    
    let serviceId: String
    var accessToken: String?
    let keychain: Keychain
    
    init() {
        serviceId = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String
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
    
    public func loginSuccess(token: String) {
        saveAccessToken(token: token)
    }
    
    public func logout() {
        saveAccessToken(token: nil)
    }
    
}
