//
//  Customer.swift
//  hse
//
//  Created by Kimmo Lahdenkangas on 05/04/16.
//  Copyright © 2016 Volvo. All rights reserved.
//

import Foundation

@objcMembers public class Customer: NSObject, Codable {

    public dynamic var id: Int = -1
    public dynamic var volvoCustomerId: String?
    public dynamic var email: String?
    public dynamic var firstName: String?
    public dynamic var lastName: String?
    public dynamic var languageCode: String?
    public dynamic var marketCode: String?
    public dynamic var phoneNumber: String?
    public dynamic var phoneNumberVerified: Bool = false
    public dynamic var passwordResetRequired: Bool = false
    public dynamic var credit: Int?
    public dynamic var currencyId: Int?
    public dynamic var photoUrl: String?
    public dynamic var enabled: Bool = true
    public dynamic var location: Location?
    public dynamic var createdAt: Date?
    public dynamic var updatedAt: Date?
    public dynamic var lastLoginAt: Date? // might be null
    
    private enum CodingKeys: String, CodingKey {
        case id
        case volvoCustomerId = "volvo_customer_id"
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case languageCode = "language_code"
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
        case lastLoginAt = "last_login_at"
    }
    
    convenience required public init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        self.volvoCustomerId = try container.decodeIfPresent(String.self, forKey: .volvoCustomerId)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        self.marketCode = try container.decodeIfPresent(String.self, forKey: .marketCode)
        self.languageCode = try container.decodeIfPresent(String.self, forKey: .languageCode)
        self.phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
        self.phoneNumberVerified = try container.decodeIfPresent(Bool.self, forKey: .phoneNumberVerified) ?? false
        self.passwordResetRequired = try container.decodeIfPresent(Bool.self, forKey: .passwordResetRequired) ?? false
        self.credit = try container.decodeIfPresent(Int.self, forKey: .credit)
        self.currencyId = try container.decodeIfPresent(Int.self, forKey: .currencyId)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.enabled = try container.decodeIfPresent(Bool.self, forKey: .enabled) ?? true
        self.location = try container.decodeIfPresent(Location.self, forKey: .location)
        self.createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        self.updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
        self.lastLoginAt = try container.decodeIfPresent(Date.self, forKey: .lastLoginAt)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(volvoCustomerId, forKey: .volvoCustomerId)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(firstName, forKey: .firstName)
        try container.encodeIfPresent(lastName, forKey: .lastName)
        try container.encodeIfPresent(languageCode, forKey: .languageCode)
        try container.encodeIfPresent(marketCode, forKey: .marketCode)
        try container.encodeIfPresent(phoneNumber, forKey: .phoneNumber)
        try container.encode(phoneNumberVerified, forKey: .phoneNumberVerified)
        try container.encode(passwordResetRequired, forKey: .passwordResetRequired)
        try container.encodeIfPresent(credit, forKey: .credit)
        try container.encodeIfPresent(currencyId, forKey: .currencyId)
        try container.encodeIfPresent(photoUrl, forKey: .photoUrl)
        try container.encode(enabled, forKey: .enabled)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(updatedAt, forKey: .updatedAt)
        try container.encodeIfPresent(lastLoginAt, forKey: .lastLoginAt)
    }
    
    public func fullName() -> String {
        return "\(firstName ?? "") \(lastName ?? "")"
    }
}
