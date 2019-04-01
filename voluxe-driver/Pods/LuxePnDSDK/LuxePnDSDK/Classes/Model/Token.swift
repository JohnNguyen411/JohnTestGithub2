//
//  Token.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 12/8/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

public class Token: Codable {
    
    public var token: String
    public var user: TokenUser?
    public var issuedAt: Date?
    public var expiresAt: Date?
    
    
    private enum CodingKeys: String, CodingKey {
        case token
        case user
        case issuedAt = "issued_at" 
        case expiresAt = "expires_at" 
    }
    
    private enum UserKeys: String, CodingKey {
        case id
        case type
    }
    
    public struct TokenUser : Codable {
        public let id: Int
        let type: String
    }
}
