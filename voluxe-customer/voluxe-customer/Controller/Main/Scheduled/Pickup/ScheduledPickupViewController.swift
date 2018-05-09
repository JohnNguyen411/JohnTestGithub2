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
    
    convenience init(vehicle: Vehicle, state: ServiceState) {
        self.init(vehicle: vehicle, screenName: AnalyticsConstants.paramNameActiveInboundView)
        stateDidChange(state: state)
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: vehicle) else {
            return
        }
        if let pickupRequest = booking.pickupRequest, let location = pickupRequest.location, let coordinates = location.getLocation(), !Config.sharedInstance.isMock {
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
        if let pickupRequest = booking.pickupRequest {
            var refreshTimeSlot = true

            if let driver = pickupRequest.driver, let location = driver.location, let coordinates = location.getLocation(), !Config.sharedInstance.isMock, state != .pickupScheduled {
                self.mapVC.updateDriverLocation(location: coordinates, refreshTime: booking.getRefreshTime())
                if let pickupRequestLocation = pickupRequest.location, let pickupRequestCoordinates = pickupRequestLocation.getLocation() {
                    self.getEta(fromLocation: coordinates, toLocation: pickupRequestCoordinates)
                    refreshTimeSlot = false
                }
                newDriver(driver: driver)
            }
            
            if let timeSlot = pickupRequest.timeSlot, refreshTimeSlot {
                timeWindowView.setTimeWindows(timeWindows: timeSlot.getTimeSlot(calendar: Calendar.current, showAMPM: true) ?? "")
            }
        }
    }
}
