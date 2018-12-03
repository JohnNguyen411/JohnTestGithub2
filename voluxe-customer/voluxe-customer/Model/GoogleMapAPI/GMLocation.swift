//
//  GMLocation.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 5/8/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class GMLocation: Codable {
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    private enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
    
    func getLocation() -> CLLocationCoordinate2D? {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}
