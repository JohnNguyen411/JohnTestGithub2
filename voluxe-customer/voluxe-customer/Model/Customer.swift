//
//  Customer.swift
//  hse
//
//  Created by Kimmo Lahdenkangas on 05/04/16.
//  Copyright © 2016 Volvo. All rights reserved.
//

import Foundation
import CoreLocation
import RealmSwift

@objcMembers class Customer: Object, Codable {

    dynamic var id: Int = -1
    dynamic var volvoCustomerId: String?
    dynamic var email: String?
    dynamic var firstName: String?
    dynamic var lastName: String?
    dynamic var marketCode: String?
    dynamic var phoneNumber: String?
    dynamic var phoneNumberVerified: Bool = false
    dynamic var passwordResetRequired: Bool = false
    dynamic var credit = RealmOptional<Int>()
    dynamic var currencyId = RealmOptional<Int>()
    dynamic var photoUrl: String?
    dynamic var enabled: Bool = true
    dynamic var location: Location?
    dynamic var createdAt: Date?
    dynamic var updatedAt: Date?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case volvoCustomerId = "volvo_customer_id"
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case marketCode = "market_code"
        case phoneNumber = "phone_number"
        case phoneNumberVerified = "phone_number_verified"
        case passwordResetRequired = "password_reset_required"
        case credit
        case currencyId = "currency_id"
        case photoUrl = "photo_url"
        case location
        case enabled
        case createdAt = "created_at" 
        case updatedAt = "updated_at" 
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        self.volvoCustomerId = try container.decodeIfPresent(String.self, forKey: .volvoCustomerId)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        self.marketCode = try container.decodeIfPresent(String.self, forKey: .marketCode)
        self.phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
        self.phoneNumberVerified = try container.decodeIfPresent(Bool.self, forKey: .phoneNumberVerified) ?? false
        self.passwordResetRequired = try container.decodeIfPresent(Bool.self, forKey: .passwordResetRequired) ?? false
        self.credit = try container.decodeIfPresent(RealmOptional<Int>.self, forKey: .credit) ?? RealmOptional<Int>()
        self.currencyId = try container.decodeIfPresent(RealmOptional<Int>.self, forKey: .currencyId) ?? RealmOptional<Int>()
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.enabled = try container.decodeIfPresent(Bool.self, forKey: .enabled) ?? true
        self.location = try container.decodeIfPresent(Location.self, forKey: .location)
        self.createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        self.updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(volvoCustomerId, forKey: .volvoCustomerId)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(firstName, forKey: .firstName)
        try container.encodeIfPresent(lastName, forKey: .lastName)
        try container.encodeIfPresent(marketCode, forKey: .marketCode)
        try container.encodeIfPresent(phoneNumber, forKey: .phoneNumber)
        try container.encode(phoneNumberVerified, forKey: .phoneNumberVerified)
        try container.encode(passwordResetRequired, forKey: .passwordResetRequired)
        try container.encode(credit, forKey: .credit)
        try container.encode(currencyId, forKey: .currencyId)
        try container.encodeIfPresent(photoUrl, forKey: .photoUrl)
        try container.encode(enabled, forKey: .enabled)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(updatedAt, forKey: .updatedAt)
    }
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
