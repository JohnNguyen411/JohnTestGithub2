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
    dynamic var availableLoanerVehicleCount: Int? = 0
    dynamic var availableAssignmentCount: Int? = 0
    
    private enum CodingKeys: String, CodingKey {
        case id
        case dealershipId = "dealership_id"
        case type
        case from //TODO: VLISODateTransform?
        case to //TODO: VLISODateTransform?
        case availableLoanerVehicleCount = "available_loaner_vehicle_count"
        case availableAssignmentCount = "available_assignment_count"
        case createdAt = "created_at" //TODO: VLISODateTransform?
        case updatedAt = "updated_at" //TODO: VLISODateTransform?
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
