//
//  Location.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 2/26/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import CoreLocation

@objcMembers public class Location: NSObject, Codable {
    
    public dynamic var id = UUID().uuidString
    public dynamic var address: String?
    public dynamic var latitude: Double = 0.0
    public dynamic var longitude: Double = 0.0
    public dynamic var accuracy: Double = 0.0
    public dynamic var createdAt: Date?
    public dynamic var updatedAt: Date?
    public dynamic var location: CLLocationCoordinate2D?
    
    private enum CodingKeys: String, CodingKey {
        case address
        case latitude
        case longitude
        case accuracy
        case createdAt = "created_at" 
        case updatedAt = "updated_at" 
    }
    
    convenience required public init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.address = try container.decodeIfPresent(String.self, forKey: .address)
        self.latitude = try container.decodeIfPresent(Double.self, forKey: .latitude) ?? 0.0
        self.longitude = try container.decodeIfPresent(Double.self, forKey: .longitude) ?? 0.0
        self.accuracy = try container.decodeIfPresent(Double.self, forKey: .accuracy) ?? 0.0
        self.createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        self.updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(address, forKey: .address)
        try container.encodeIfPresent(latitude, forKey: .latitude)
        try container.encodeIfPresent(longitude, forKey: .longitude)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(updatedAt, forKey: .updatedAt)
    }
    
 
    convenience public init(name: String?, latitude: Double?, longitude: Double?, location: CLLocationCoordinate2D?) {
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
    
    
    public func getLocation() -> CLLocationCoordinate2D? {
        if let location = location {
            return location
        }
        
        location = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        
        return location
    }
    
    public func getShortAddress() -> String? {
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
    
    public func getMediumAddress() -> String? {
        if let address = address {
            let tok = address.components(separatedBy:",")
            var shortAddress = ""
            if tok.count > 0 {
                for (index, string) in tok.enumerated() {
                    if index > 2 {
                        break
                    }
                    shortAddress += string + ","
                }
                shortAddress.removeLast()
                
                let split = shortAddress.split(separator: " ")
                if let lastChar = shortAddress.last, let unicode = Unicode.Scalar(String(lastChar)), split.count > 4 && CharacterSet.decimalDigits.contains(unicode) {
                    shortAddress = String(split.prefix(upTo: split.count - 1).joined(separator: [" "]))
                }
                
                return shortAddress
            }
        }
        return address
    }
    
    public func toJSON() -> [String : Any] {
        return [
            "address": address ?? "",
            "latitude": latitude,
            "longitude": longitude,
            "accuracy": accuracy
        ]
    }
    
    // Return distance between 2 locations in meters
    public static func distanceBetweenLocations(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
        let locationFrom = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let locationTo = CLLocation(latitude: to.latitude, longitude: to.longitude)
        
        return locationFrom.distance(from: locationTo)
    }
}
