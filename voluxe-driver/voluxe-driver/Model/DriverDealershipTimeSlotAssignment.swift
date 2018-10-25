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
    let driver_id: Int
    let dealership_time_slot_id: Int
    let state: String
    let created_at: String  // TODO need date
    let updated_at: String  // TODO need date
}
