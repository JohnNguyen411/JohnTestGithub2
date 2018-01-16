//
//  RequestLocation.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/17/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreLocation
import RealmSwift

class RequestLocation: Object, Mappable {
    
    @objc dynamic var id: Int = -1
    @objc dynamic var bookingId: Int = -1
    @objc dynamic var name: String?
    @objc dynamic var address: String?
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    @objc dynamic var accuracy: Int = 0
    @objc dynamic var state: String?
    var location: CLLocationCoordinate2D?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        bookingId <- map["booking_id"]
        name <- map["name"]
        address <- map["address"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        accuracy <- map["accuracy"]
        state <- map["state"]
    }
    
    override static func ignoredProperties() -> [String] {
        return ["location"]
    }
    
    convenience init(name: String?, latitude: Double?, longitude: Double?, location: CLLocationCoordinate2D?) {
        self.init()
        self.name = name
        if let latitude = latitude {
            self.latitude = latitude
        }
        if let longitude = longitude {
            self.longitude = longitude
        }
        self.location = location
    }
    
    
    func getLocation() -> CLLocationCoordinate2D? {
        if let location = location {
            return location
        }
        
        location = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        
        return location
    }
}
