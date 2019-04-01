//
//  VehicleMake.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 4/6/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

@objcMembers public class VehicleMake: NSObject, Codable {
    
    public dynamic var id: Int = -1
    public dynamic var name: String?
    public dynamic var managed: Bool = true
    public dynamic var createdAt: Date?
    public dynamic var updatedAt: Date?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case managed
        case createdAt = "created_at" 
        case updatedAt = "updated_at" 
    }
}
