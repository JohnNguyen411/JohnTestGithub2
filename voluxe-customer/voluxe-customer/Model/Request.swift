//
//  Request.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/17/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class Request: Object, Codable {
    
    dynamic var id: Int = -1
    dynamic var bookingId: Int = -1
    dynamic var timeslotId: Int = -1
    dynamic var state: String = "requested"
    dynamic var type: String?
    dynamic var createdAt: Date?
    dynamic var updatedAt: Date?
    dynamic var driver: Driver?
    dynamic var location: Location?
    dynamic var timeSlot: DealershipTimeSlot?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case bookingId = "booking_id"
        case timeslotId = "driver_dealership_time_slot_assignment_id"
        case location
        case timeSlot = "dealership_time_slot"
        case state
        case type
        case driver = "driver_dealership_time_slot_assignment.driver"
        case createdAt = "created_at" //TODO: VLISODateTransform?
        case updatedAt = "updated_at" //TODO: VLISODateTransform?
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
    func getState() -> RequestState {
        return RequestState(rawValue: state)!
    }
    
    func getType() -> RequestType? {
        if let type = type {
            return RequestType(rawValue: type)!
        }
        return nil
    }
    
    func isToday() -> Bool {
        if let timeSlot = timeSlot, let from = timeSlot.from {
            return from.isToday
        }
        return false
    }
    
}

public enum RequestState: String {
    case requested = "requested"
    case started = "started"
    case completed = "completed"
    case cancelled = "cancelled"
}
