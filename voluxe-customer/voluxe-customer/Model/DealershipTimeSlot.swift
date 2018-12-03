//
//  DealershipTimeSlot.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 1/18/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import CoreLocation
import RealmSwift

@objcMembers class DealershipTimeSlot: Object, Codable {
    
    dynamic var id: Int = -1
    dynamic var dealershipId: Int = -1
    dynamic var type: String?
    dynamic var from: Date?
    dynamic var to: Date?
    dynamic var createdAt: Date?
    dynamic var updatedAt: Date?
    dynamic var availableLoanerVehicleCount = RealmOptional<Int>()
    dynamic var availableAssignmentCount = RealmOptional<Int>()
    
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
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        self.dealershipId = try container.decodeIfPresent(Int.self, forKey: .dealershipId) ?? -1
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.from = try container.decodeIfPresent(Date.self, forKey: .from)
        self.to = try container.decodeIfPresent(Date.self, forKey: .to)
        self.availableLoanerVehicleCount = try container.decodeIfPresent(RealmOptional<Int>.self, forKey: .availableLoanerVehicleCount) ?? RealmOptional<Int>()
        self.availableAssignmentCount = try container.decodeIfPresent(RealmOptional<Int>.self, forKey: .availableAssignmentCount) ?? RealmOptional<Int>()
        self.createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        self.updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
    }
    
    func encode(to encoder: Encoder) throws {
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
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func getTimeSlot(calendar: Calendar, showAMPM: Bool, shortSymbol: Bool? = nil) -> String? {
        guard let from = from, let to = to else { return nil }
        
        if showAMPM {
            let hourFrom = Calendar.current.component(.hour, from: from)
            let hourTo = Calendar.current.component(.hour, from: to)
            
            if hourFrom < 12 && hourTo < 12 {
                return "\(Date.formatHourMin(date: from, calendar: calendar, showAMPM: false, shortSymbol: shortSymbol))–\(Date.formatHourMin(date: to, calendar: calendar, showAMPM: showAMPM, shortSymbol: shortSymbol))"
            } else if hourFrom >= 12 && hourTo > 12 {
                return "\(Date.formatHourMin(date: from, calendar: calendar, showAMPM: false, shortSymbol: shortSymbol))–\(Date.formatHourMin(date: to, calendar: calendar, showAMPM: showAMPM, shortSymbol: shortSymbol))"
            } else {
                return "\(Date.formatHourMin(date: from, calendar: calendar, showAMPM: showAMPM, shortSymbol: shortSymbol))–\(Date.formatHourMin(date: to, calendar: calendar, showAMPM: showAMPM, shortSymbol: shortSymbol))"
            }
            
        } else {
            return "\(Date.formatHourMin(date: from, calendar: calendar, showAMPM: showAMPM, shortSymbol: shortSymbol))–\(Date.formatHourMin(date: to, calendar: calendar, showAMPM: showAMPM, shortSymbol: shortSymbol))"
        }
    }
}
