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
    
    private var customer: Customer?
    private var vehicles: [Vehicle]?
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
    
    public func setCustomer(customer: Customer) {
        self.customer = customer
    }
    
    public func setVehicles(vehicles: [Vehicle]) {
        self.vehicles = vehicles
    }
    
    public func getVehicles() -> [Vehicle]? {
        return vehicles
    }
    
    public func getVehicle() -> Vehicle? {
        if let vehicles = vehicles, vehicles.count > 0 {
            return vehicles[0]
        }
        return nil
    }
    
    public func getVehicleId() -> Int? {
        if let vehicles = vehicles, vehicles.count > 0 {
            return vehicles[0].id
        }
        return nil
    }
    
    public func getCustomer() -> Customer? {
        if let customer = customer {
            return customer
        }
        return nil
    }
    
    public func getCustomerId() -> Int? {
        if let customer = customer {
            return customer.id
        }
        return nil
    }
    
}
