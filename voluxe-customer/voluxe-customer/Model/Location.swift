//
//  Location.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 2/26/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreLocation
import RealmSwift

class Location: Object, Mappable {
    
    @objc dynamic var id = UUID().uuidString
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
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(name: String?, latitude: Double?, longitude: Double?, location: CLLocationCoordinate2D?) {
        self.init()
        self.address = name
        
        if let location = location {
            self.location = location
            self.latitude = location.latitude
            self.longitude = location.longitude
        } else {
            if let latitude = latitude {
                self.latitude = latitude
            }
            if let longitude = longitude {
                self.longitude = longitude
            }
        }
    }
    
    
    func getLocation() -> CLLocationCoordinate2D? {
        if let location = location {
            return location
        }
        
        location = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        
        return location
    }
    
    func getShortAddress() -> String? {
        if let address = address {
            let tok = address.components(separatedBy:",")
            var shortAddress = ""
            if tok.count > 0 {
                for (index, string) in tok.enumerated() {
                    if index > 1 {
                        break
                    }
                    shortAddress += string + ","
                }
                shortAddress.removeLast()
                return shortAddress
            }
        }
        return address
    }
    
    func toJSON() -> [String : Any] {
        return [
            "address": address ?? "",
            "latitude": latitude,
            "longitude": longitude,
            "accuracy": accuracy
        ]
    }
}
