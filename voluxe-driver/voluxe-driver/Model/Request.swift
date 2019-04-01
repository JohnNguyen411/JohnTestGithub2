//
//  Request.swift
//  voluxe-driver
//
//  Created by Christoph on 10/24/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation

struct Request: Codable {

    enum State: String, Codable {
        case canceled
        case completed
        case requested
        case started
    }

    enum `Type`: String, Codable {
        case advisorPickup = "advisor_pickup"
        case advisorDropoff = "advisor_dropoff"
        case dropoff = "driver_dropoff"
        case pickup = "driver_pickup"
    }

    let id: Int
    let type: Type
    let booking: Booking?
    let bookingId: Int
    let dealershipTimeSlotId: Int
    let dealershipTimeSlot: DealershipTimeSlot
    let notes: String?
    let location: Location?
    let state: State
    let task: Task?
    let driverDealershipTimeSlotAssignmentId: Int
    let driverDealershipTimeSlotAssignment: DriverDealershipTimeSlotAssignment?
    let loanerVehicleRequested: Bool?
    let loanerInspection: Inspection?
    let loanerInspectionId: Int?
    let vehicleInspectionId: Int?
    let vehicleInspection: Inspection?
    let documents: [Inspection]?

    enum CodingKeys: String, CodingKey {
        case id
        case type
        case booking
        case bookingId = "booking_id"
        case dealershipTimeSlotId = "dealership_time_slot_id"
        case dealershipTimeSlot = "dealership_time_slot"
        case notes
        case location
        case state
        case task
        case driverDealershipTimeSlotAssignmentId = "driver_dealership_time_slot_assignment_id"
        case driverDealershipTimeSlotAssignment = "driver_dealership_time_slot_assignment"
        case loanerVehicleRequested = "loaner_vehicle_requested"
        case loanerInspection = "loaner_vehicle_inspection"
        case vehicleInspectionId = "vehicle_inspection_id"
        case loanerInspectionId = "loaner_vehicle_inspection_id"
        case vehicleInspection = "vehicle_inspection"
        case documents
    }

    
}
