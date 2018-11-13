//
//  User.swift
//  voluxe-driver
//
//  Created by Christoph on 10/22/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation

// TODO need coding keys
struct Driver: Codable {
    let id: Int
    let email: String
    let first_name: String
    let last_name: String
    let language_code: String
    let password_reset_required: Bool
    let last_login_at: Date
    let work_phone_number: String
    let work_phone_number_verified: Bool
    let personal_phone_number: String?
    let personal_phone_number_verified: Bool?
    let photo_url: String
    let type: String
    let enabled: Bool
}
