//
//  DealershipRepairOrder.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 3/19/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

@objcMembers public class DealershipRepairOrder: NSObject, Codable {
    
    public dynamic var id: Int = -1
    public dynamic var dealershipId = -1
    public dynamic var repairOrderTypeId = -1
    public dynamic var repairOrderType: RepairOrderType?
    public dynamic var enabled: Bool = true
    public dynamic var createdAt: Date?
    public dynamic var updatedAt: Date?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case dealershipId = "dealership_id"
        case repairOrderTypeId = "repair_order_type_id"
        case repairOrderType = "repair_order_type"
        case enabled
        case createdAt = "created_at" 
        case updatedAt = "updated_at" 
    }
    
    convenience required public init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        self.dealershipId = try container.decodeIfPresent(Int.self, forKey: .dealershipId) ?? -1
        self.repairOrderTypeId = try container.decodeIfPresent(Int.self, forKey: .repairOrderTypeId) ?? -1
        self.repairOrderType = try container.decodeIfPresent(RepairOrderType.self, forKey: .repairOrderType)
        self.enabled = try container.decodeIfPresent(Bool.self, forKey: .enabled) ?? true
        self.createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        self.updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(repairOrderTypeId, forKey: .repairOrderTypeId)
        try container.encodeIfPresent(repairOrderType, forKey: .repairOrderType)
        try container.encode(enabled, forKey: .enabled)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(updatedAt, forKey: .updatedAt)
    }
}
