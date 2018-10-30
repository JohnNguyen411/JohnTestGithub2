//
//  Request.swift
//  voluxe-driver
//
//  Created by Christoph on 10/24/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation

struct Request: Codable {

    enum `Type`: String, Codable {
        case advisorPickup = "advisor_pickup"
        case advisorDropoff = "advisor_dropoff"
        case dropoff = "driver_dropoff"
        case pickup = "driver_pickup"
    }

    let id: Int
    let type: Type
    let booking: Booking
    let dealership_time_slot_id: Int
    let dealership_time_slot: DealershipTimeSlot
    let notes: String?
    let location: Location?
    let state: String
    let task: String?
    let driver_dealership_time_slot_assignment_id: Int
    let driver_dealership_time_slot_assignment: DriverDealershipTimeSlotAssignment?
    let vehicle_inspection_id: Int?
    let vehicle_inspection: Inspection?
    let documents: [String]?
    let created_at: String  // TODO need date
    let updated_at: String  // TODO need date
}
