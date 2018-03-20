//
//  DealershipRepairOrder.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 3/19/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class DealershipRepairOrder: Object, Mappable {
    
    @objc dynamic var id: Int = -1
    @objc dynamic var dealershipId = -1
    @objc dynamic var repairOrderTypeId = -1
    @objc dynamic var enabled: Bool = true
    @objc dynamic var createdAt: Date?
    @objc dynamic var updatedAt: Date?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        dealershipId <- map["dealership_id"]
        repairOrderTypeId <- map["repair_order_type_id"]
        enabled <- map["enabled"]
        createdAt <- (map["created_at"], VLISODateTransform())
        updatedAt <- (map["updated_at"], VLISODateTransform())
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
