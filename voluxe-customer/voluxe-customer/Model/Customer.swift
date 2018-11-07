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

    var id: Int = -1
    var volvoCustomerId: String?
    var email: String?
    var firstName: String?
    var lastName: String?
    var marketCode: String?
    var phoneNumber: String?
    var phoneNumberVerified: Bool = false
    var passwordResetRequired: Bool = false
    var credit: Int = 0
    var currencyId: Int = 0
    var photoUrl: String?
    var enabled: Bool = true
    var location: Location?
    var createdAt: Date?
    var updatedAt: Date?
    
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
