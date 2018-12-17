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
    let booking: Booking
    let dealershipTimeSlotId: Int
    let dealershipTimeSlot: DealershipTimeSlot
    let notes: String?
    let location: Location?
    let state: State
    let task: String?
    let driverDealershipTimeSlotAssignmentId: Int
    let driverDealershipTimeSlotAssignment: DriverDealershipTimeSlotAssignment?
    let loanerVehicleRequested: Bool?
    let loanerInspection: Inspection?
    let vehicleInspectionId: Int?
    let vehicleInspection: Inspection?
    let documents: [Inspection]?

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
        case loanerVehicleRequested = "loaner_vehicle_requested"
        case loanerInspection = "loaner_vehicle_inspection"
        case vehicleInspectionId = "vehicle_inspection_id"
        case vehicleInspection = "vehicle_inspection"
        case documents
    }

    var isDropOff: Bool {
        return self.type == .advisorPickup || self.type == .dropoff
    }

    var isPickup: Bool {
        return self.type == .advisorPickup || self.type == .pickup
    }

    var isStarted: Bool {
        return self.state == .started
    }

    var isCompleted: Bool {
        return self.state == .completed
    }
}
