//
//  Location.swift
//  voluxe-driver
//
//  Created by Christoph on 10/23/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation

struct Location: Codable {

    let address: String
    let latitude: Double
    let longitude: Double
}

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
        let string = "\(city.trim()), \(street.trim())"
        return string
    }
}
