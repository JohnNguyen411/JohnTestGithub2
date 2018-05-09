//
//  GMLocation.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 5/8/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import ObjectMapper

class GMLocation: NSObject, Mappable {
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        latitude = map["latitude"].currentValue as! Double
        longitude = map["longitude"].currentValue as! Double
    }
    
    func mapping(map: Map) {
        latitude <- map["latitude"]
        longitude <- map["longitude"]
    }
    
    func getLocation() -> CLLocationCoordinate2D? {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}
