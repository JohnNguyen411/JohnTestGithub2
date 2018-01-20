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
    @objc dynamic var state: String?
    @objc dynamic var createdAt: Date?
    @objc dynamic var updatedAt: Date?
    @objc dynamic var location: Location?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        bookingId <- map["booking_id"]
        timeslotId <- map["driver_dealership_time_slot_assignment_id"]
        location <- map["location"]
        createdAt <- (map["created_at"], VLISODateTransform())
        updatedAt <- (map["updated_at"], VLISODateTransform())
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
}
