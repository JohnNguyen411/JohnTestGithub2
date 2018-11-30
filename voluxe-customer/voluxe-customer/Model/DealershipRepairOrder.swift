//
//  DealershipRepairOrder.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 3/19/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class DealershipRepairOrder: Object, Codable {
    
    dynamic var id: Int = -1
    dynamic var dealershipId = -1
    dynamic var repairOrderTypeId = -1
    dynamic var enabled: Bool = true
    dynamic var createdAt: Date?
    dynamic var updatedAt: Date?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case dealershipId = "dealership_id"
        case repairOrderTypeId = "repair_order_type_id"
        case enabled
        case createdAt = "created_at" 
        case updatedAt = "updated_at" 
    }
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
