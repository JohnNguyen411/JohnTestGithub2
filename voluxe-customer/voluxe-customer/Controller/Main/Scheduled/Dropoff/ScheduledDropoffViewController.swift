//
//  ScheduledDropoffViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/16/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
import SlideMenuControllerSwift
import CoreLocation
import GoogleMaps

class ScheduledDropoffViewController: ScheduledViewController {
    
    override func generateStates() {
        states = [ServiceState.enRouteForDropoff, ServiceState.enRouteForDropoff, ServiceState.enRouteForDropoff, ServiceState.enRouteForDropoff,
                  ServiceState.enRouteForDropoff, ServiceState.enRouteForDropoff, ServiceState.nearbyForDropoff, ServiceState.nearbyForDropoff,
                  ServiceState.arrivedForDropoff]
    }
    
    override func generateSteps() {
        let step1 = Step(id: ServiceState.serviceCompleted, text: .VehicleIsReady, state: .done)
        let step2 = Step(id: ServiceState.enRouteForDropoff, text: .DriverEnRoute)
        let step3 = Step(id: ServiceState.nearbyForDropoff, text: .DriverNearby)
        let step4 = Step(id: ServiceState.arrivedForDropoff, text: .DriverArrived)
        
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
