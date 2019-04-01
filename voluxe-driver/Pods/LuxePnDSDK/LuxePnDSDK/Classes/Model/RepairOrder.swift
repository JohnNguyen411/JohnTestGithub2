//
//  RepairOrder.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 1/16/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

@objcMembers public class RepairOrder: NSObject, Codable {
    
    public dynamic var id: Int = -1
    public dynamic var bookingId: Int = -1
    public dynamic var dealershipRepairOrderId: Int = -1
    public dynamic var notes: String = ""
    public dynamic var state: String?
    public dynamic var vehicleDrivable = true
    public dynamic var repairOrderType: RepairOrderType?
    public dynamic var name: String?
    public dynamic var title: String?
    public dynamic var createdAt: Date?
    public dynamic var updatedAt: Date?
    
    // Driver Fields
    public dynamic var repairOrderId: String?
    public dynamic var dealershipRepairOrder: DealershipRepairOrder?
    public dynamic var roDescription: String?
    public dynamic var completedAt: Date?
    public dynamic var startedAt: Date?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case bookingId = "booking_id"
        case repairOrderId = "repair_order_id"
        case dealershipRepairOrderId = "dealership_repair_order_id"
        case notes
        case state
        case vehicleDrivable = "vehicle_drivable"
        case dealershipRepairOrder = "dealership_repair_order"
        case title
        case roDescription = "description"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case completedAt = "completed_at"
        case startedAt = "started_at"
    }
    
    
    private enum DealershipRepairOrderKeys: String, CodingKey {
        case repairOrderType = "repair_order_type"
    }
    
    private enum RepairOrderTypeKeys: String, CodingKey {
        case name = "name"
    }
    
    convenience required public init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        self.bookingId = try container.decodeIfPresent(Int.self, forKey: .bookingId) ?? -1
        self.dealershipRepairOrderId = try container.decodeIfPresent(Int.self, forKey: .dealershipRepairOrderId) ?? -1
        self.notes = try container.decodeIfPresent(String.self, forKey: .notes) ?? ""
        self.state = try container.decodeIfPresent(String.self, forKey: .state)
        self.vehicleDrivable = try container.decodeIfPresent(Bool.self, forKey: .vehicleDrivable) ?? true
        
        self.dealershipRepairOrder = try container.decodeIfPresent(DealershipRepairOrder.self, forKey: .dealershipRepairOrder)
        let dealershipRepairOrderContainer = try container.nestedContainer(keyedBy: DealershipRepairOrderKeys.self, forKey: .dealershipRepairOrder)
        let repairOrderTypeContainer = try dealershipRepairOrderContainer.nestedContainer(keyedBy: RepairOrderTypeKeys.self, forKey: .repairOrderType)
        self.repairOrderType = try dealershipRepairOrderContainer.decodeIfPresent(RepairOrderType.self, forKey: .repairOrderType)
        self.name = try repairOrderTypeContainer.decodeIfPresent(String.self, forKey: .name)

        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        self.updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(bookingId, forKey: .bookingId)
        try container.encode(dealershipRepairOrderId, forKey: .dealershipRepairOrderId)
        try container.encode(notes, forKey: .notes)
        try container.encodeIfPresent(state, forKey: .state)
        try container.encodeIfPresent(vehicleDrivable, forKey: .vehicleDrivable)
        var dealershipROContainer = encoder.container(keyedBy: DealershipRepairOrderKeys.self)
        try dealershipROContainer.encodeIfPresent(repairOrderType, forKey: .repairOrderType)
        var repairOrderTypeContainer = encoder.container(keyedBy: RepairOrderTypeKeys.self)
        try repairOrderTypeContainer.encodeIfPresent(name, forKey: RepairOrderTypeKeys.name)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(roDescription, forKey: .roDescription)
        try container.encodeIfPresent(repairOrderId, forKey: .repairOrderId)
        try container.encodeIfPresent(dealershipRepairOrder, forKey: .dealershipRepairOrder)
        try container.encodeIfPresent(completedAt, forKey: .completedAt)
        try container.encodeIfPresent(startedAt, forKey: .startedAt)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(updatedAt, forKey: .updatedAt)
    }
    
    convenience public init(title: String, repairOrderType: RepairOrderType, customerDescription: String, drivable: Bool?) {
        self.init()
        self.name = title
        self.title = title
        self.repairOrderType = repairOrderType
        self.notes = customerDescription
        self.vehicleDrivable = drivable ?? true
    }
    
    public func getTitle() -> String {
        if let title = title {
            return title
        } else if let name = self.name {
            return name
        } else if let repairOrderType = self.repairOrderType, let typeName = repairOrderType.name {
                return typeName
        }
        return ""
    }
}
