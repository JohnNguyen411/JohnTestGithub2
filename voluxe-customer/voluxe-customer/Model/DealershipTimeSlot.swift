//
//  DealershipTimeSlot.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 1/18/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreLocation
import RealmSwift

class DealershipTimeSlot: Object, Mappable {
    
    @objc dynamic var id: Int = -1
    @objc dynamic var dealershipId: Int = -1
    @objc dynamic var type: String?
    @objc dynamic var from: Date?
    @objc dynamic var to: Date?
    @objc dynamic var createdAt: Date?
    @objc dynamic var updatedAt: Date?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        dealershipId <- map["dealership_id"]
        type <- map["type"]
        from <- (map["from"], VLISODateTransform())
        to <- (map["to"], VLISODateTransform())
        createdAt <- (map["created_at"], VLISODateTransform())
        updatedAt <- (map["updated_at"], VLISODateTransform())
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func getTimeSlot(calendar: Calendar) -> String? {
        guard let from = from, let to = to else {
            return nil
        }/*
        let fromHour = calendar.component(.hour, from: from)
        let fromMinutes = calendar.component(.minute, from: from)
        let toHour = calendar.component(.hour, from: to)
        let toMinutes = calendar.component(.minute, from: to)
 */
        
        return "\(Date.formatHourMin(date: from, calendar: calendar)) - \(Date.formatHourMin(date: to, calendar: calendar))"
    }
}
