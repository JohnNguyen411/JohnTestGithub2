//
//  Location.swift
//  hse
//
//  Created by Kimmo Lahdenkangas on 05/04/16.
//  Copyright © 2016 Volvo. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreLocation
import RealmSwift

class Location: Object, Mappable {
    
    @objc dynamic var address: String?
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    @objc dynamic var accuracy: Int = 0
    @objc dynamic var createdAt: Date?
    @objc dynamic var updatedAt: Date?
    var location: CLLocationCoordinate2D?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        address <- map["address"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        accuracy <- map["accuracy"]
        createdAt <- (map["created_at"], VLISODateTransform())
        updatedAt <- (map["updated_at"], VLISODateTransform())
    }
    
    override static func ignoredProperties() -> [String] {
        return ["location"]
    }
    
    convenience init(name: String?, latitude: Double?, longitude: Double?, location: CLLocationCoordinate2D?) {
        self.init()
        self.address = name
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
