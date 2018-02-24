//
//  State.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 2/15/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

public enum State: String {
    case cancelled = "cancelled"
    case created = "created"
    case pickupScheduled = "pickup_scheduled"
    case enRouteForPickup = "en_route_for_pickup"
    case nearbyForPickup = "nearby_for_pickup"
    case arrivedForPickup = "arrived_for_pickup"
    case enRouteForService = "en_route_for_service"
    case service = "service"
    case serviceCompleted = "service_completed"
    case dropoffScheduled = "dropoff_scheduled"
    case enRouteForDropoff = "en_route_for_dropoff"
    case nearbyForDropoff = "nearby_for_dropoff"
    case arrivedForDropoff = "arrived_for_dropoff"
    case completed = "completed"
    
    static func isPickup(state: State) -> Bool {
        return state == .pickupScheduled || state == .enRouteForPickup || state == .nearbyForPickup || state == .arrivedForPickup || state == .enRouteForService
    }
}




