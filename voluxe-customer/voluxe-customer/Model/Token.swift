//
//  Token.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 12/8/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class Token: Codable {
    
    var token: String
    var customerId: Int?
    var issuedAt: Date?
    var expiresAt: Date?
    var userType: String?
    
    private enum CodingKeys: String, CodingKey {
        case token
        case customerId = "customer_id"
        case issuedAt = "issued_at" //TODO: VLISODateTransform?
        case expiresAt = "expires_at" //TODO: VLISODateTransform?
        case userType = "user_type"
    }
    
}
