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
    var user: User?
    var issuedAt: Date?
    var expiresAt: Date?
    
    
    private enum CodingKeys: String, CodingKey {
        case token
        case user
        case issuedAt = "issued_at" //TODO: VLISODateTransform?
        case expiresAt = "expires_at" //TODO: VLISODateTransform?
    }
    
    private enum UserKeys: String, CodingKey {
        case id
        case type
    }
    
    struct User : Codable {
        let id: Int
        let type: String
    }
}
