//
//  Location.swift
//  hse
//
//  Created by Kimmo Lahdenkangas on 05/04/16.
//  Copyright © 2016 Volvo. All rights reserved.
//

import Foundation
import ObjectMapper

class Location: NSObject, Mappable {
    var longitude: Double
    var latitude: Double
    var address: String?
    var note: String?

    init(longitude: Double, latitude: Double, address: String?, note: String?) {
        self.longitude = longitude
        self.latitude = latitude
        self.address = address
        self.note = note
    }

    init(dict: [String : AnyObject]) {
        self.address = dict["address"] as? String
        self.note = dict["note"] as? String
        self.longitude = (dict["longitude"] as! NSNumber).doubleValue
        self.latitude = (dict["latitude"] as! NSNumber).doubleValue
    }

    required init?(map: Map) {
        longitude = map["longitude"].currentValue as! Double
        latitude = map["latitude"].currentValue as! Double
        address = map["address"].currentValue as? String
        note = map["note"].currentValue as? String
    }

    func mapping(map: Map) {
        longitude <- map["longitude"]
        latitude <- map["latitude"]
        address <- map["address"]
        note <- map["note"]
    }

    override func isEqual(_ other: Any?) -> Bool {
        if let other = other as? Location {
            return self.latitude == other.latitude && self.longitude == other.longitude
        }

        return false
    }
}
