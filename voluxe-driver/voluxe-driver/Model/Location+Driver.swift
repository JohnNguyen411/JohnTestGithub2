//
//  Location+Driver.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 4/1/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation

extension Location {
    
    enum Components: Int {
        case street = 0
        case city
        case state
        case country
    }
    
    // TODO https://app.asana.com/0/858610969087925/946622779263339/f
    // TODO clean up
    var cityStreetAddressString: String {
        let components = self.address.components(separatedBy: ",")
        let city = components.count > Components.city.rawValue ? components[Components.city.rawValue] : "Unknown"
        let street = components.count > Components.street.rawValue ? components[Components.street.rawValue] : "Unknown"
        let string = "\(street.trim()), \(city.trim())"
        return string
    }
}
