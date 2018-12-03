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
    
    dynamic var id: Int = -1
    dynamic var bookingId: Int = -1
    dynamic var dealershipRepairOrderId: Int = -1
    dynamic var notes: String = ""
    dynamic var state: String?
    dynamic var vehicleDrivable = RealmOptional<Bool>()
    dynamic var repairOrderType: RepairOrderType?
    dynamic var name: String?
    dynamic var title: String?
    dynamic var createdAt: Date?
    dynamic var updatedAt: Date?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case bookingId = "booking_id"
        case dealershipRepairOrderId = "dealership_repair_order_id"
        case notes
        case state
        case vehicleDrivable = "vehicle_drivable"
        case repairOrderType = "dealership_repair_order.repair_order_type"
        case name = "dealership_repair_order.repair_order_type.name"
        case title
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        self.bookingId = try container.decodeIfPresent(Int.self, forKey: .bookingId) ?? -1
        self.dealershipRepairOrderId = try container.decodeIfPresent(Int.self, forKey: .dealershipRepairOrderId) ?? -1
        self.notes = try container.decodeIfPresent(String.self, forKey: .notes) ?? ""
        self.state = try container.decodeIfPresent(String.self, forKey: .state)
        self.vehicleDrivable = try container.decodeIfPresent(RealmOptional<Bool>.self, forKey: .vehicleDrivable) ?? RealmOptional<Bool>()
        self.repairOrderType = try container.decodeIfPresent(RepairOrderType.self, forKey: .repairOrderType)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        self.updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(bookingId, forKey: .bookingId)
        try container.encode(dealershipRepairOrderId, forKey: .dealershipRepairOrderId)
        try container.encode(notes, forKey: .notes)
        try container.encodeIfPresent(state, forKey: .state)
        try container.encodeIfPresent(vehicleDrivable, forKey: .vehicleDrivable)
        try container.encodeIfPresent(repairOrderType, forKey: .repairOrderType)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(updatedAt, forKey: .updatedAt)
    }
    
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
