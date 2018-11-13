//
//  Customer.swift
//  voluxe-driver
//
//  Created by Christoph on 10/24/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation

struct Customer: Codable {

    let id: Int
    let email: String
    let firstName: String
    let lastName: String
    let languageCode: String
    let passwordResetRequired: Bool
    let lastLoginAt: Date
    let phoneNumber: String
    let phoneNumberVerified: Bool
    let photoUrl: String
    let location: Location?
    let type: String?
    let enabled: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case languageCode = "language_code"
        case passwordResetRequired = "password_reset_required"
        case lastLoginAt = "last_login_at"
        case phoneNumber = "phone_number"
        case phoneNumberVerified = "phone_number_verified"
        case photoUrl = "photo_url"
        case location
        case type
        case enabled
    }
}

