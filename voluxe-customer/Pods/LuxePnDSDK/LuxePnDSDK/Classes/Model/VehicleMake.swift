//
//  VehicleMake.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 4/6/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

public class VehicleMake: NSObject, Codable {
    
    public var id: Int = -1
    public var name: String?
    public var managed: Bool = true
    public var createdAt: Date?
    public var updatedAt: Date?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case managed
        case createdAt = "created_at" 
        case updatedAt = "updated_at" 
    }
}
