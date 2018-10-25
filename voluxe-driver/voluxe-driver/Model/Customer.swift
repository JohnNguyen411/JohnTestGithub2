//
//  Customer.swift
//  voluxe-driver
//
//  Created by Christoph on 10/24/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation

// TODO need coding keys
// TODO need Date type
struct Customer: Codable {
    let id: Int
    let email: String
    let first_name: String
    let last_name: String
    let language_code: String
    let password_reset_required: Bool
    let last_login_at: String
    let phone_number: String
    let phone_number_verified: Bool
    let photo_url: String
    let location: Location?
    let type: String?
    let enabled: Bool
    let created_at: String
    let updated_at: String
}

