//
//  Dealership.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/17/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import CoreLocation
import RealmSwift

@objcMembers class Dealership: Object, Codable {
    
    dynamic var id: Int = -1
    dynamic var name: String?
    dynamic var phoneNumber: String?
    dynamic var email: String?
    dynamic var location: Location?
    dynamic var hoursOfOperation: String?
    dynamic var coverageRadius: Int = 1
    dynamic var currencyId: Int? = 1
    dynamic var enabled: Bool = true
    dynamic var createdAt: Date?
    dynamic var updatedAt: Date?
    
    convenience init(name: String?, location: CLLocationCoordinate2D?) {
        self.init()
        self.name = name
        self.location = Location(name: nil, latitude: nil, longitude: nil, location: location)
    }
    
    convenience init(name: String?) {
        self.init(name: name, location: nil)
    }
    
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
        case createdAt = "created_at" //TODO: VLISODateTransform?
        case updatedAt = "updated_at" //TODO: VLISODateTransform?
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
