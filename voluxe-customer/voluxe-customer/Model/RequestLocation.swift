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

class RequestLocation: NSObject, Mappable {
    
    var name: String?
    var stringLocation: String? // "37.788866,-122.398210"
    var location: CLLocationCoordinate2D?
    
    override init() {
        super.init()
    }
    
    init(name: String?, stringLocation: String?, location: CLLocationCoordinate2D?) {
        self.name = name
        self.stringLocation = stringLocation
        self.location = location
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        stringLocation <- map["location"]
    }
    
    func getLocation() -> CLLocationCoordinate2D? {
        if let location = location {
            return location
        }
        
        location = LocationUtils.getLocation(stringLocation: stringLocation)
        
        return location
    }
}
