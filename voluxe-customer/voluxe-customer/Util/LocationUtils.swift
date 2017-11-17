//
//  LocationUtils.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/17/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import CoreLocation

class LocationUtils {
    
    class func getLocation(stringLocation: String?) -> CLLocationCoordinate2D? {
        var location: CLLocationCoordinate2D?
        if let stringLocation = stringLocation {
            if let indexStartOfcoma = stringLocation.index(of: ",") {
                
                let lat = stringLocation[...indexStartOfcoma]
                let long = stringLocation[indexStartOfcoma...]
                
                if let degLat = CLLocationDegrees(lat), let degLong = CLLocationDegrees(long) {
                    location = CLLocationCoordinate2DMake(degLat, degLong)
                }
            }
        }
        return location
    }
}
