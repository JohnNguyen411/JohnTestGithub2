//
//  Dealership.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/17/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreLocation
import RealmSwift

class Dealership: Object, Mappable {
    
    @objc dynamic var id: Int = -1
    @objc dynamic var name: String?
    @objc dynamic var phoneNumber: String?
    @objc dynamic var location: Location?
    @objc dynamic var coverageRadius: Int = 1
    @objc dynamic var currencyId: Int = 1
    @objc dynamic var enabled: Bool = true
    @objc dynamic var createdAt: Date?
    @objc dynamic var updatedAt: Date?
    
    convenience init(name: String?, location: CLLocationCoordinate2D?) {
        self.init()
        self.name = name
        self.location = Location(name: nil, latitude: nil, longitude: nil, location: location)
    }
    
    convenience init(name: String?) {
        self.init(name: name, location: nil)
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        phoneNumber <- map["phone_number"]
        location <- map["location"]
        coverageRadius <- map["coverage_radius"]
        currencyId <- map["currency_id"]
        enabled <- map["enabled"]
        createdAt <- (map["created_at"], VLISODateTransform())
        updatedAt <- (map["updated_at"], VLISODateTransform())
    }
}
