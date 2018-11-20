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
    dynamic var currencyId: Int = 1
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
    
    
    /*
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        phoneNumber <- map["phone_number"]
        email <- map["email"]
        location <- map["location"]
        hoursOfOperation <- map["hours_of_operation"]
        coverageRadius <- map["coverage_radius"]
        currencyId <- map["currency_id"]
        enabled <- map["enabled"]
        createdAt <- (map["created_at"], VLISODateTransform())
        updatedAt <- (map["updated_at"], VLISODateTransform())
    }
    */
    override static func primaryKey() -> String? {
        return "id"
    }
}
