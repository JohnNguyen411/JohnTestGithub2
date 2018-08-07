//
//  StateService.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/16/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import SwiftEventBus

final class StateServiceManager {
    
    private var states = [Int: ServiceState]() // states dict (Vehicle Id : State)
    
    static let sharedInstance = StateServiceManager()
    
    init() {
    }
    
    func updateState(state: ServiceState, vehicleId: Int, booking: Booking?) {
        var oldState = states[vehicleId]
        if oldState == nil || oldState != state {
            // state did change
            states[vehicleId] = state
            if oldState == nil {
                oldState = .noninit
            }
            
            SwiftEventBus.post("stateDidChange", sender: StateChangeObject(vehicleId: vehicleId, oldState: oldState, newState: state))
            if let booking = booking {
                Analytics.trackChangeBooking(state: booking.state, id: booking.id)
            }
            BookingSyncManager.sharedInstance.syncBookings()
        }  else {
            // update if needed, like request location change or timewindow
            SwiftEventBus.post("updateBookingIfNeeded")
            
            if state == .enRouteForDropoff || state == .enRouteForPickup || state == .nearbyForPickup || state == .nearbyForDropoff {
                // update driver's location
                SwiftEventBus.post("driverLocationUpdate")
            }
        }
        
        if let booking = booking {
            if state == .completed || booking.getState() == .canceled {
                BookingSyncManager.sharedInstance.stopTimerForBooking(bookingId: booking.id)
            }
        }
    }
    
   
    func getState(vehicleId: Int) -> ServiceState {
        if let serviceState = states[vehicleId] {
            return serviceState
        }
        return .noninit
    }
    
    func isPickup(vehicleId: Int) -> Bool {
        return ServiceState.isPickup(state: getState(vehicleId: vehicleId))
    }
}

final class StateChangeObject {
    let vehicleId: Int
    let oldState: ServiceState?
    let newState: ServiceState
    
    init(vehicleId: Int, oldState: ServiceState?, newState: ServiceState) {
        self.vehicleId = vehicleId
        self.oldState = oldState
        self.newState = newState
    }
}
