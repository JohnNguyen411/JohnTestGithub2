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
    
    convenience init(vehicle: Vehicle, state: ServiceState) {
        self.init(vehicle: vehicle, screenName: AnalyticsConstants.paramNameActiveOutboundView)
        stateDidChange(state: state)
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: vehicle) else {
            return
        }
        if let dropoffRequest = booking.dropoffRequest, let location = dropoffRequest.location, let coordinates = location.getLocation(), !Config.sharedInstance.isMock {
            mapVC.updateRequestLocation(location: coordinates)
            
            weak var weakSelf = self
            // force refresh camera update after 1 sec
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                weakSelf?.mapVC.updateRequestLocation(location: coordinates)
            })
        }
    }
    
    override func stateDidChange(state: ServiceState) {
        super.stateDidChange(state: state)
        driverLocationUpdate()
    }
    
    override func driverLocationUpdate() {
        super.driverLocationUpdate()
        
        guard let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: vehicle) else {
            return
        }
        let state = StateServiceManager.sharedInstance.getState(vehicleId: vehicle.id)

        if let dropoffRequest = booking.dropoffRequest {
            var refreshTimeSlot = true
            
            if let driver = dropoffRequest.driver, let location = driver.location, let coordinates = location.getLocation(), !Config.sharedInstance.isMock, state != .pickupScheduled {
                self.mapVC.updateDriverLocation(location: coordinates, refreshTime: booking.getRefreshTime())
                if let dropoffRequestLocation = dropoffRequest.location, let dropoffRequestCoordinates = dropoffRequestLocation.getLocation() {
                    refreshTimeSlot = false
                    self.getEta(fromLocation: coordinates, toLocation: dropoffRequestCoordinates)
                }
                newDriver(driver: driver)
            }
            if let timeSlot = dropoffRequest.timeSlot, refreshTimeSlot {
                timeWindowView.setTimeWindows(timeWindows: timeSlot.getTimeSlot(calendar: Calendar.current, showAMPM: true) ?? "")
            }
        }
    }
    
}
