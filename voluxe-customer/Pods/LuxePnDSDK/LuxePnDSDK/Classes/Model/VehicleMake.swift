//
//  VehicleMake.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 4/6/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

@objcMembers class VehicleMake: NSObject, Codable {
    
    dynamic var id: Int = -1
    dynamic var name: String?
    dynamic var managed: Bool = true
    dynamic var createdAt: Date?
    dynamic var updatedAt: Date?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case managed
        case createdAt = "created_at" 
        case updatedAt = "updated_at" 
    }
}
