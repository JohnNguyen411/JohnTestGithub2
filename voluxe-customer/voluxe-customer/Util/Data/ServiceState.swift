//
//  ServiceState.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/15/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

public enum ServiceState: Int {
    case noninit = -999 // app state
    case loading = 0  // app state
    case idle = 5  // app state
    case needService = 10  // app state
    case schedulingService = 15  // app state
    case pickupScheduled = 20
    case enRouteForPickup = 21
    case nearbyForPickup = 22
    case arrivedForPickup = 23
    case enRouteForService = 24
    case service = 30
    case serviceCompleted = 40
    case schedulingDelivery = 45  // app state
    case dropoffScheduled = 50
    case enRouteForDropoff = 51
    case nearbyForDropoff = 52
    case arrivedForDropoff = 53
    case completed = 60
    
    static func isPickup(state: ServiceState) -> Bool {
        return state.rawValue <= 25
    }
    
    static func appStateForBookingState(bookingState: State) -> ServiceState {
        
         // pickup
        if bookingState == .pickupScheduled {
            return .pickupScheduled
        } else if bookingState == .enRouteForPickup {
            return .enRouteForPickup
        } else if bookingState == .nearbyForPickup {
            return .nearbyForPickup
        } else if bookingState == .arrivedForPickup {
            return .arrivedForPickup
        } else if bookingState == .enRouteForService {
            return .enRouteForService
        }
        // service
        else if bookingState == .service {
            return .service
        }
        else if bookingState == .serviceCompleted {
            return .serviceCompleted
        }
        // dropoff
        else if bookingState == .dropoffScheduled {
            return .dropoffScheduled
        }
        else if bookingState == .enRouteForDropoff {
            return .enRouteForDropoff
        }
        else if bookingState == .nearbyForDropoff {
            return .nearbyForDropoff
        }
        else if bookingState == .arrivedForDropoff {
            return .arrivedForDropoff
        } else if bookingState == .canceled {
            return .idle
        }
        else {
            return .completed
        }
        
        
    }
}
