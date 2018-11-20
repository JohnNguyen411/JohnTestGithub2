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
    dynamic var credit: Int? = 0
    dynamic var currencyId: Int? = 0
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
        case createdAt = "created_at" //TODO: VLISODateTransform?
        case updatedAt = "updated_at" //TODO: VLISODateTransform?
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
