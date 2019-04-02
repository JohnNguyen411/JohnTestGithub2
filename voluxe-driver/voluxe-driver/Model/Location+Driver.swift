//
//  Location+Driver.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 4/1/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import CoreLocation

extension Location {
    
    public convenience init(address: String, latitude: Double, longitude: Double) {
        self.init(name: address, latitude: latitude, longitude: longitude, location: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
    }
    
    enum Components: Int {
        case street = 0
        case city
        case state
        case country
    }
    
    // TODO https://app.asana.com/0/858610969087925/946622779263339/f
    // TODO clean up
    var cityStreetAddressString: String {
        
        guard let address = self.address else {
            return ""
        }
        
        let components = address.components(separatedBy: ",")
        let city = components.count > Components.city.rawValue ? components[Components.city.rawValue] : "Unknown"
        let street = components.count > Components.street.rawValue ? components[Components.street.rawValue] : "Unknown"
        let string = "\(street.trim()), \(city.trim())"
        return string
    }
}
