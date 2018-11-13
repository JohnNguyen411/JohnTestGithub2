//
//  Booking.swift
//  voluxe-driver
//
//  Created by Christoph on 10/24/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation

// TODO need coding keys
struct Booking: Codable {
    let id: Int
    let state: String
    let customer_id: Int
    let customer: Customer
    let booking_feedback_id: Int?
    let booking_feedback: BookingFeedback?
    let vehicle_id: Int?
    let vehicle: Vehicle?
    let dealership_id: Int
    let dealership: Dealership?
    let loaner_vehicle_requested: Bool
    let loaner_vehicle_id: Int?
    let loaner_vehicle: Vehicle?
//    let repair_order_requests: [String]  // TODO type?
}
