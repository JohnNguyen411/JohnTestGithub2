//
//  ServiceState.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/15/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

public enum ServiceState: Int {
    case noninit = -999
    case idle = 0
    case needService = 10
    case schedulingService = 15
    case pickupScheduled = 20
    case pickupDriverInRoute = 21
    case pickupDriverNearby = 22
    case pickupDriverArrived = 23
    case pickupDriverDrivingToDealership = 24
    case pickupDriverAtDealership = 25
    case servicing = 30
    case serviceCompleted = 40
    case schedulingDelivery = 45
    case deliveryScheduled = 50
    case deliveryInRoute = 51
    case deliveryNearby = 52
    case deliveryArrived = 53
    
    static func isPickup(state: ServiceState) -> Bool {
        return state.rawValue <= 25
    }
}
