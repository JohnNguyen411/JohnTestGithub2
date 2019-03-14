//
//  Dealership.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/17/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import CoreLocation

@objcMembers class Dealership: NSObject, Codable {
    
    dynamic var id: Int = -1
    dynamic var name: String?
    dynamic var phoneNumber: String?
    dynamic var email: String?
    dynamic var location: Location?
    dynamic var hoursOfOperation: String?
    dynamic var coverageRadius: Int = 1
    dynamic var currencyId: Int = -1
    dynamic var enabled: Bool = true
    dynamic var createdAt: Date?
    dynamic var updatedAt: Date?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case phoneNumber = "phone_number"
        case email
        case location
        case hoursOfOperation = "hours_of_operation"
        case coverageRadius = "coverage_radius"
        case currencyId = "currency_id"
        case enabled
        case createdAt = "created_at" 
        case updatedAt = "updated_at" 
    }
    
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.location = try container.decodeIfPresent(Location.self, forKey: .location)
        self.hoursOfOperation = try container.decodeIfPresent(String.self, forKey: .hoursOfOperation)
        self.coverageRadius = try container.decodeIfPresent(Int.self, forKey: .coverageRadius) ?? 1
        self.currencyId = try container.decodeIfPresent(Int.self, forKey: .currencyId) ?? -1
        self.enabled = try container.decodeIfPresent(Bool.self, forKey: .enabled) ?? true
        self.createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        self.updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(phoneNumber, forKey: .phoneNumber)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(location, forKey: .location)
        try container.encodeIfPresent(hoursOfOperation, forKey: .hoursOfOperation)
        try container.encodeIfPresent(coverageRadius, forKey: .coverageRadius)
        try container.encodeIfPresent(currencyId, forKey: .currencyId)
        try container.encode(enabled, forKey: .enabled)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(updatedAt, forKey: .updatedAt)
    }
    
    convenience init(name: String?, location: CLLocationCoordinate2D?) {
        self.init()
        self.name = name
        self.location = Location(name: nil, latitude: nil, longitude: nil, location: location)
    }
    
    convenience init(name: String?) {
        self.init(name: name, location: nil)
    }
}
