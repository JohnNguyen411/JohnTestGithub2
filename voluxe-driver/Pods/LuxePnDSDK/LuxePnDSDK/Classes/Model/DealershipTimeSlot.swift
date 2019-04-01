//
//  DealershipTimeSlot.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 1/18/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

@objcMembers public class DealershipTimeSlot: NSObject, Codable {
    
    public dynamic var id: Int = -1
    public dynamic var dealershipId: Int = -1
    public dynamic var type: String?
    public dynamic var from: Date?
    public dynamic var to: Date?
    public dynamic var createdAt: Date?
    public dynamic var updatedAt: Date?
    public dynamic var availableLoanerVehicleCount = -1
    public dynamic var availableAssignmentCount = -1
    
    private enum CodingKeys: String, CodingKey {
        case id
        case dealershipId = "dealership_id"
        case type
        case from 
        case to 
        case availableLoanerVehicleCount = "available_loaner_vehicle_count"
        case availableAssignmentCount = "available_assignment_count"
        case createdAt = "created_at" 
        case updatedAt = "updated_at" 
    }
    
    convenience required public init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        self.dealershipId = try container.decodeIfPresent(Int.self, forKey: .dealershipId) ?? -1
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.from = try container.decodeIfPresent(Date.self, forKey: .from)
        self.to = try container.decodeIfPresent(Date.self, forKey: .to)
        self.availableLoanerVehicleCount = try container.decodeIfPresent(Int.self, forKey: .availableLoanerVehicleCount) ?? -1
        self.availableAssignmentCount = try container.decodeIfPresent(Int.self, forKey: .availableAssignmentCount) ?? -1
        self.createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        self.updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(dealershipId, forKey: .dealershipId)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(from, forKey: .from)
        try container.encodeIfPresent(to, forKey: .to)
        try container.encodeIfPresent(availableLoanerVehicleCount, forKey: .availableLoanerVehicleCount)
        try container.encodeIfPresent(availableAssignmentCount, forKey: .availableAssignmentCount)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(updatedAt, forKey: .updatedAt)
    }
 
}
