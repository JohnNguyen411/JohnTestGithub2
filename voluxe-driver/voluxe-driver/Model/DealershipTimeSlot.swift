//
//  DealershipTimeSlot.swift
//  voluxe-driver
//
//  Created by Christoph on 10/24/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation

struct DealershipTimeSlot: Codable {

    let id: Int
    let dealershipId: Int
    let type: String
    let from: Date
    let to: Date
    let availableLoanerVehicleCount: Int?
    let availableAssignmentCount: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case dealershipId = "dealership_id"
        case type
        case from
        case to
        case availableLoanerVehicleCount = "available_loaner_vehicle_count"
        case availableAssignmentCount = "available_assignment_count"
    }
}
