//
//  DriverDealershipTimeSlotAssignment.swift
//  voluxe-driver
//
//  Created by Christoph on 10/24/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation

struct DriverDealershipTimeSlotAssignment: Codable {

    let id: Int
    let driverId: Int?
    let dealershipTimeSlotId: Int
    let state: String

    enum CodingKeys: String, CodingKey {
        case id
        case driverId = "driver_id"
        case dealershipTimeSlotId = "dealership_time_slot_id"
        case state
    }
}
