//
//  VehicleLocation.swift
//  hse
//
//  Created by Kimmo Lahdenkangas on 10/10/16.
//  Copyright © 2016 Volvo. All rights reserved.
//

import Foundation

class VehicleLocation {

    var vehicle: Vehicle
    var location: Location

    init(vehicle: Vehicle, location: Location) {
        self.vehicle = vehicle
        self.location = location
    }
}
