//
//  Request.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/17/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

@objcMembers class Request: NSObject, Codable {
    
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
        case driverAssignment = "driver_dealership_time_slot_assignment"
        case driver
        case createdAt = "created_at" 
        case updatedAt = "updated_at" 
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        self.bookingId = try container.decodeIfPresent(Int.self, forKey: .bookingId) ?? -1
        self.timeslotId = try container.decodeIfPresent(Int.self, forKey: .timeslotId) ?? -1
        self.location = try container.decodeIfPresent(Location.self, forKey: .location)
        self.timeSlot = try container.decodeIfPresent(DealershipTimeSlot.self, forKey: .timeSlot)
        self.state = try container.decodeIfPresent(String.self, forKey: .state) ?? ""
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        
        if container.contains(.driverAssignment) {
            if let driverAssignment = try? container.nestedContainer(keyedBy: CodingKeys.self, forKey: .driverAssignment) {
                self.driver = try driverAssignment.decodeIfPresent(Driver.self, forKey: .driver)
            } else {
                self.driver = nil
            }
        } else {
            self.driver = nil
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(bookingId, forKey: .bookingId)
        try container.encode(timeslotId, forKey: .timeslotId)
        try container.encode(state, forKey: .state)
        try container.encode(location, forKey: .location)
        try container.encode(timeSlot, forKey: .timeSlot)
        try container.encode(type, forKey: .type)
        var driverAssignment = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .driverAssignment)
        try driverAssignment.encode(driver, forKey: .driver)

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
