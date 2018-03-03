//
//  Request.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/17/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Request: Object, Mappable {
    
    @objc dynamic var id: Int = -1
    @objc dynamic var bookingId: Int = -1
    @objc dynamic var timeslotId: Int = -1
    @objc dynamic var state: String = "requested"
    @objc dynamic var createdAt: Date?
    @objc dynamic var updatedAt: Date?
    @objc dynamic var driver: Driver?
    @objc dynamic var location: Location?
    @objc dynamic var timeSlot: DealershipTimeSlot?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        bookingId <- map["booking_id"]
        timeslotId <- map["driver_dealership_time_slot_assignment_id"]
        location <- map["location"]
        timeSlot <- map["dealership_time_slot"]
        state <- map["state"]
        driver <- map["driver_dealership_time_slot_assignment.driver"]
        createdAt <- (map["created_at"], VLISODateTransform())
        updatedAt <- (map["updated_at"], VLISODateTransform())
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
    func getState() -> RequestState {
        return RequestState(rawValue: state)!
    }
    
    func isToday() -> Bool {
        if let timeSlot = timeSlot, let from = timeSlot.from {
            return from.isToday
        }
        return false
    }
    
    
    static func mockRequest(bookingId: Int, location: Location, timeSlot: DealershipTimeSlot) -> Request {
        let request = Request()
        request.id = Int(arc4random_uniform(99999)) + 1
        request.bookingId = bookingId
        request.location = location
        request.timeSlot = timeSlot
        request.timeslotId = timeSlot.id
        return request
    }
    
}
public enum RequestState: String {
    case requested = "requested"
    case started = "started"
    case completed = "completed"
    case cancelled = "cancelled"
}
