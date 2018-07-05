//
//  BookingFeedback.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 6/25/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreLocation
import RealmSwift
import Realm

class BookingFeedback: Object, Mappable {
    
    @objc dynamic var id: Int = -1
    @objc dynamic var bookingId: Int = -1
    @objc dynamic var rating: Int = -1
    @objc dynamic var comment: String?
    @objc dynamic var state: String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        bookingId <- map["booking_id"]
        rating <- map["rating"]
        comment <- map["comment"]
        state <- map["state"]
    }

    override static func primaryKey() -> String? {
        return "id"
    }
    
    public func needsRating() -> Bool {
        return state != nil && state! == "pending"
    }
    
}
