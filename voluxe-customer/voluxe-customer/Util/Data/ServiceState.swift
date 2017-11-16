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
    case scheduled = 10
    case pickupDriverInRoute = 11
    case pickupDriverNearby = 12
    case pickupDriverArrived = 13
}
