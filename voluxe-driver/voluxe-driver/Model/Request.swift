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
    let dealershipTimeSlotId: Int
    let dealershipTimeSlot: DealershipTimeSlot
    let notes: String?
    let location: Location?
    let state: String
    let task: String?
    let driverDealershipTimeSlotAssignmentId: Int
    let driverDealershipTimeSlotAssignment: DriverDealershipTimeSlotAssignment?
    let vehicleInspectionId: Int?
    let vehicleInspection: Inspection?
    let documents: [String]?

    enum CodingKeys: String, CodingKey {
        case id
        case type
        case booking
        case dealershipTimeSlotId = "dealership_time_slot_id"
        case dealershipTimeSlot = "dealership_time_slot"
        case notes
        case location
        case state
        case task
        case driverDealershipTimeSlotAssignmentId = "driver_dealership_time_slot_assignment_id"
        case driverDealershipTimeSlotAssignment = "driver_dealership_time_slot_assignment"
        case vehicleInspectionId = "vehicle_inspection_id"
        case vehicleInspection = "vehicle_inspection"
        case documents
    }
}
