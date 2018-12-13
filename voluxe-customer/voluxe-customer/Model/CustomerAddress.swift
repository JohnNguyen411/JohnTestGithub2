//
//  CustomerAddress.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 2/9/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import CoreLocation
import RealmSwift

@objcMembers class CustomerAddress: Object, Codable {
    
    dynamic var id = UUID().uuidString
    dynamic var volvoCustomerId: String?
    dynamic var location: Location?
    dynamic var label: String? // Work / Home / Gym etc
    dynamic var createdAt: Date?
    dynamic var updatedAt: Date?
    dynamic var luxeCustomerId: Int = -1
    
    
    convenience init(id: String?) {
        self.init()
        if let id = id {
            self.id = id
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case location
        case label
        case luxeCustomerId = "customer_id"
        case createdAt = "created_at" 
        case updatedAt = "updated_at" 
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

