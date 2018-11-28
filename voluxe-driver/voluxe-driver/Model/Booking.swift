//
//  Booking.swift
//  voluxe-driver
//
//  Created by Christoph on 10/24/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation

struct Booking: Codable {

    let id: Int
    let state: String
    let customer: Customer
    let bookingFeedback: BookingFeedback?
    let vehicle: Vehicle?
    let dealership: Dealership?
    let loanerVehicleRequested: Bool
    let loanerVehicle: Vehicle?

    enum CodingKeys: String, CodingKey {
        case id
        case state
        case customer
        case bookingFeedback = "booking_feedback"
        case vehicle
        case dealership
        case loanerVehicleRequested = "loaner_vehicle_requested"
        case loanerVehicle = "loaner_vehicle"
    }
}
