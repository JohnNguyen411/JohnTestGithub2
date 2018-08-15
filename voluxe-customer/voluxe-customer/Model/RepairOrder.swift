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
    let vehicleDrivable = RealmOptional<Bool>()
    @objc dynamic var repairOrderType: RepairOrderType?
    @objc dynamic var name: String?
    @objc dynamic var title: String?
    
    convenience init(title: String, repairOrderType: RepairOrderType, customerDescription: String, drivable: Bool?) {
        self.init()
        self.name = title
        self.title = title
        self.repairOrderType = repairOrderType
        self.notes = customerDescription
        if let drivable = drivable {
            self.vehicleDrivable.value = drivable
        } else {
            self.vehicleDrivable.value = nil
        }
    }
    
    convenience init(repairOrderType: RepairOrderType) {
        self.init()
        self.title = repairOrderType.name
        self.name = repairOrderType.name
        if repairOrderType.getCategory() == .custom {
            self.name = String.DiagnosticInspection
        }
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
        title <- map["title"]
        if let repairOrderType = repairOrderType, repairOrderType.getCategory() == .custom {
            self.name = String.DiagnosticInspection
        }
        vehicleDrivable.value <- map["vehicle_drivable"]
    }
    
    static func getDrivabilityTitle(isDrivable: Bool?) -> String {
        if let drivable = isDrivable {
            if drivable {
                return .Yes
            } else {
                return .No
            }
        } else {
            return .ImNotSure
        }
    }
}
