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
    
    private var delegates: [StateServiceManagerProtocol] = []
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
            delegates.forEach {delegate in
                delegate.stateDidChange(vehicleId: vehicleId, oldState: oldState!, newState: state)
            }
            
            SwiftEventBus.post("stateDidChange", sender: Vehicle(id: vehicleId))
            if let booking = booking {
                VLAnalytics.logEventWithName(AnalyticsConstants.eventStateChange, paramName: AnalyticsConstants.paramNameState, paramValue: "\(booking.state)")
            }

            BookingSyncManager.sharedInstance.syncBookings()
        } else if state == .enRouteForDropoff || state == .enRouteForPickup || state == .nearbyForPickup || state == .nearbyForDropoff {
            // update driver's location
            SwiftEventBus.post("driverLocationUpdate")
        }
        
        if let booking = booking {
            if state == .completed || booking.getState() == .canceled {
                BookingSyncManager.sharedInstance.stopTimerForBooking(bookingId: booking.id)
            }
        }
    }
    
    func addDelegate(delegate: StateServiceManagerProtocol) {
        delegates.append(delegate)
    }
    
    func removeDelegate(delegate: StateServiceManagerProtocol) {
        if let index = delegates.index(where: { $0 === delegate }) {
            delegates.remove(at: index)
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

protocol StateServiceManagerProtocol: class {
    func stateDidChange(vehicleId: Int, oldState: ServiceState, newState: ServiceState)
}
