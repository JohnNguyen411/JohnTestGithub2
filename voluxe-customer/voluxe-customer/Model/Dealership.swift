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
    @objc dynamic var address: String?
    @objc dynamic var locationLatitude: Double = 0
    @objc dynamic var locationLongitude: Double = 0
    @objc dynamic var coverageRadius: Int = 1
    @objc dynamic var currencyId: Int = 1
    @objc dynamic var enabled: Bool = true

    var location: CLLocationCoordinate2D?
    
    convenience init(name: String?, location: CLLocationCoordinate2D?) {
        self.init()
        self.name = name
        self.location = location
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
        address <- map["address"]
        locationLatitude <- map["location_latitude"]
        locationLongitude <- map["location_longitude"]
        coverageRadius <- map["coverage_radius"]
        currencyId <- map["currency_id"]
        enabled <- map["enabled"]
        location = CLLocationCoordinate2DMake(locationLatitude, locationLongitude)
    }
    
    override static func ignoredProperties() -> [String] {
        return ["location"]
    }

}
