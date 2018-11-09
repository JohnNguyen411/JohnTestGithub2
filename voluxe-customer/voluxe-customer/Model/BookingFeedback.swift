//
//  BookingFeedback.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 6/25/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import CoreLocation
import RealmSwift
import Realm

@objcMembers class BookingFeedback: Object, Codable {
    
    var id: Int = -1
    var bookingId: Int = -1
    var rating: Int = -1
    var comment: String?
    var state: String?
    
    /*
    func mapping(map: Map) {
        id <- map["id"]
        bookingId <- map["booking_id"]
        rating <- map["rating"]
        comment <- map["comment"]
        state <- map["state"]
    }
 */

    override static func primaryKey() -> String? {
        return "id"
    }
    
    public func needsRating() -> Bool {
        return state != nil && state! == "pending"
    }
    
}
