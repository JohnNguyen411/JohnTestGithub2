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
    
    var id: Int = -1
    var dealershipId = -1
    var repairOrderTypeId = -1
    var enabled: Bool = true
    var createdAt: Date?
    var updatedAt: Date?
    
    /*
    func mapping(map: Map) {
        id <- map["id"]
        dealershipId <- map["dealership_id"]
        repairOrderTypeId <- map["repair_order_type_id"]
        enabled <- map["enabled"]
        createdAt <- (map["created_at"], VLISODateTransform())
        updatedAt <- (map["updated_at"], VLISODateTransform())
    }
    */
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
