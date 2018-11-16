//
//  RepairOrder.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 1/16/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class RepairOrder: Object, Codable {
    
    var id: Int = -1
    var bookingId: Int = -1
    var dealershipRepairOrderId: Int = -1
    var notes: String = ""
    var state: String?
    let vehicleDrivable = RealmOptional<Bool>()
    var repairOrderType: RepairOrderType?
    var name: String?
    var title: String?
    var createdAt: Date?
    var updatedAt: Date?
    
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
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case bookingId = "booking_id"
        case dealershipRepairOrderId = "dealership_repair_order_id"
        case notes
        case state
        case vehicleDrivable = "vehicle_drivable" //TODO check nested object parsin
        case repairOrderType = "dealership_repair_order.repair_order_type"
        case name = "dealership_repair_order.repair_order_type.name"
        case title
        case createdAt = "created_at" //TODO: VLISODateTransform?
        case updatedAt = "updated_at" //TODO: VLISODateTransform?
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
    
    func getTitle() -> String {
        if let title = title {
            return title
        } else {
            if let repairOrderType = repairOrderType, let typeName = repairOrderType.name {
                return typeName
            }
        }
        return ""
    }
}
