//
//  RepairOrderRequest.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 1/23/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation

struct RepairOrderRequest: Codable {

    let id: Int
    let bookingId: Int?
    let repairOrderId: String?
    let dealershipRepairOrderId: Int?
    let notes: String?
    let state: String?
    let vehicleDrivable: Bool?
    let dealershipRepairOrder: DealershipRepairOrder?
    let title: String?
    let description: String?
    let createdAt: Date?
    let updatedAt: Date?
    let completedAt: Date?
    let startedAt: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case bookingId = "booking_id"
        case repairOrderId = "repair_order_id"
        case dealershipRepairOrderId = "dealership_repair_order_id"
        case notes
        case state
        case vehicleDrivable = "vehicle_drivable"
        case dealershipRepairOrder = "dealership_repair_order"
        case title
        case description
        case completedAt = "completed_at"
        case startedAt = "started_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
