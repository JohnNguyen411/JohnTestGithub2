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
    
    var id: Int = -1
    var bookingId: Int = -1
    var timeslotId: Int = -1
    var state: String = "requested"
    var type: String?
    var createdAt: Date?
    var updatedAt: Date?
    var driver: Driver?
    var location: Location?
    var timeSlot: DealershipTimeSlot?
    
  /*
    func mapping(map: Map) {
        id <- map["id"]
        bookingId <- map["booking_id"]
        timeslotId <- map["driver_dealership_time_slot_assignment_id"]
        location <- map["location"]
        timeSlot <- map["dealership_time_slot"]
        state <- map["state"]
        type <- map["type"]
        driver <- map["driver_dealership_time_slot_assignment.driver"]
        createdAt <- (map["created_at"], VLISODateTransform())
        updatedAt <- (map["updated_at"], VLISODateTransform())
    }
    */
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
