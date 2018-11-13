//
//  User.swift
//  voluxe-driver
//
//  Created by Christoph on 10/22/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation

struct Driver: Codable {

    let id: Int
    let email: String
    let firstName: String
    let lastName: String
    let languageCode: String
    let passwordResetRequired: Bool
    let lastLoginAt: Date
    let workPhoneNumber: String
    let workPhoneNumberVerified: Bool
    let personalPhoneNumber: String?
    let personalPhoneNumberVerified: Bool?
    let photoUrl: String
    let type: String
    let enabled: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case languageCode = "language_code"
        case passwordResetRequired = "password_reset_required"
        case lastLoginAt = "last_login_at"
        case workPhoneNumber = "work_phone_number"
        case workPhoneNumberVerified = "work_phone_number_verified"
        case personalPhoneNumber = "personal_phone_number"
        case personalPhoneNumberVerified = "personal_phone_number_verified"
        case photoUrl = "photo_url"
        case type
        case enabled
    }
}
