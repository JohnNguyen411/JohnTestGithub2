//
//  RepairOrder.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 1/16/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class RepairOrder: Object, Mappable {
    
    @objc dynamic var id: Int = -1
    @objc dynamic var bookingId: Int = -1
    @objc dynamic var dealershipRepairOrderId: Int = -1
    @objc dynamic var notes: String = ""
    @objc dynamic var state: String?
    @objc dynamic var createdAt: Date?
    @objc dynamic var updatedAt: Date?
    var drivable: DrivableType?
    @objc dynamic var repairOrderType: RepairOrderType?
    @objc dynamic var name: String?

    convenience init(repairOrderType: RepairOrderType, customerDescription: String, drivable: DrivableType?) {
        self.init()
        self.name = .DiagnosticAndService
        self.repairOrderType = repairOrderType
        self.notes = customerDescription
        self.drivable = drivable
    }
    
    convenience init(repairOrderType: RepairOrderType) {
        self.init()
        self.name = repairOrderType.name
        self.repairOrderType = repairOrderType
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        bookingId <- map["booking_id"]
        dealershipRepairOrderId <- map["dealership_repair_order_id"]
        notes <- map["notes"]
        state <- map["state"]
        repairOrderType <- map["dealership_repair_order.repair_order_type"]
        name <- map["dealership_repair_order.repair_order_type.name"]
        createdAt <- (map["created_at"], VLISODateTransform())
        updatedAt <- (map["updated_at"], VLISODateTransform())
    }
    
    override static func ignoredProperties() -> [String] {
        return ["drivable"]
    }
    
    static func mockRepairOrder() -> RepairOrder {
        let repairOrder = RepairOrder()
        repairOrder.name = "10,000 miles checkup"
        return repairOrder
    }
    
}

public enum DrivableType {
    case yes
    case no
    case notSure
}
