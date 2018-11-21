//
//  Location.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 2/26/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import CoreLocation
import RealmSwift

@objcMembers class Location: Object, Codable {
    
    dynamic var id = UUID().uuidString
    dynamic var address: String?
    dynamic var latitude: Double = 0.0
    dynamic var longitude: Double = 0.0
    dynamic var accuracy = RealmOptional<Double>()
    dynamic var createdAt: Date?
    dynamic var updatedAt: Date?
    dynamic var location: CLLocationCoordinate2D?
    
    private enum CodingKeys: String, CodingKey {
        case address
        case latitude
        case longitude
        case accuracy
        case createdAt = "created_at" //TODO: VLISODateTransform?
        case updatedAt = "updated_at" //TODO: VLISODateTransform?
    }
    
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.address = try container.decodeIfPresent(String.self, forKey: .address)
        self.latitude = try container.decodeIfPresent(Double.self, forKey: .latitude) ?? 0.0
        self.longitude = try container.decodeIfPresent(Double.self, forKey: .longitude) ?? 0.0
        self.accuracy = try container.decodeIfPresent(RealmOptional<Double>.self, forKey: .accuracy) ?? RealmOptional<Double>()
        self.createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        self.updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(address, forKey: .address)
        try container.encodeIfPresent(latitude, forKey: .latitude)
        try container.encodeIfPresent(longitude, forKey: .longitude)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(updatedAt, forKey: .updatedAt)
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
    
    func getMediumAddress() -> String? {
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
    
    func toJSON() -> [String : Any] {
        return [
            "address": address ?? "",
            "latitude": latitude,
            "longitude": longitude,
            "accuracy": accuracy.value ?? 0
        ]
    }
    
    // Return distance between 2 locations in meters
    public static func distanceBetweenLocations(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
        let locationFrom = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let locationTo = CLLocation(latitude: to.latitude, longitude: to.longitude)
        
        return locationFrom.distance(from: locationTo)
    }
}
