//
//  DealershipRepairOrder.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 3/19/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

@objcMembers class DealershipRepairOrder: NSObject, Codable {
    
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
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        self.dealershipId = try container.decodeIfPresent(Int.self, forKey: .dealershipId) ?? -1
        self.repairOrderTypeId = try container.decodeIfPresent(Int.self, forKey: .repairOrderTypeId) ?? -1
        self.enabled = try container.decodeIfPresent(Bool.self, forKey: .enabled) ?? true
        self.createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        self.updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(repairOrderTypeId, forKey: .repairOrderTypeId)
        try container.encode(enabled, forKey: .enabled)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(updatedAt, forKey: .updatedAt)
    }
}
