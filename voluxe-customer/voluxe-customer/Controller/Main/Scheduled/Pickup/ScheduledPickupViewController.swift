//
//  ScheduledPickupViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/15/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import GoogleMaps

class ScheduledPickupViewController: ScheduledViewController {
    
    override func generateStates() {
        states = [ServiceState.enRouteForPickup, ServiceState.enRouteForPickup, ServiceState.enRouteForPickup, ServiceState.enRouteForPickup,
                  ServiceState.enRouteForPickup, ServiceState.enRouteForPickup, ServiceState.nearbyForPickup, ServiceState.nearbyForPickup,
                  ServiceState.arrivedForPickup]
    }
    
    override func generateSteps() {
        let step1 = Step(id: ServiceState.pickupScheduled, text: .ServiceScheduled, state: .done)
        let step2 = Step(id: ServiceState.enRouteForPickup, text: .DriverEnRoute)
        let step3 = Step(id: ServiceState.nearbyForPickup, text: .DriverNearby)
        let step4 = Step(id: ServiceState.arrivedForPickup, text: .DriverArrived)
        
        steps.append(step1)
        steps.append(step2)
        steps.append(step3)
        steps.append(step4)
    }
    
    override func generateDriverLocations() {
        driverLocations.append(ScheduledViewController.driverLocation1)
        driverLocations.append(ScheduledViewController.driverLocation2)
        driverLocations.append(ScheduledViewController.driverLocation3)
        driverLocations.append(ScheduledViewController.driverLocation4)
        driverLocations.append(ScheduledViewController.driverLocation5)
        driverLocations.append(ScheduledViewController.driverLocation6)
        driverLocations.append(ScheduledViewController.driverLocation7)
        driverLocations.append(ScheduledViewController.driverLocation8)
        driverLocations.append(ScheduledViewController.driverLocation9)
    }
    
}
