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
    let dealershipId: Int?
    let dealership: Dealership?
    let repairOrderRequests: [RepairOrderRequest]?
    let loanerVehicleRequested: Bool
    let loanerVehicle: Vehicle?

    enum CodingKeys: String, CodingKey {
        case id
        case state
        case customer
        case bookingFeedback = "booking_feedback"
        case vehicle
        case dealershipId = "dealership_id"
        case dealership
        case loanerVehicleRequested = "loaner_vehicle_requested"
        case loanerVehicle = "loaner_vehicle"
        case repairOrderRequests = "repair_order_requests"
    }
    
    public func repairOrderIds() -> String {
        var rosID = ""
        if let ros = self.repairOrderRequests {
            for ro in ros {
                if let roID = ro.repairOrderId {
                    rosID.append("\(roID),")
                }
            }
        }
        if rosID.count > 0 {
            rosID.removeLast()
        }
        return rosID
    }
    
    
    public func repairOrderNames() -> String {
        var rosName = ""
        if let ros = self.repairOrderRequests {
            for ro in ros {
                if let title = ro.title {
                    rosName.append("\(title),")
                } else if let dealershipRO = ro.dealershipRepairOrder, let name = dealershipRO.repairOrderType.name {
                    rosName.append("\(name),")
                }
            }
        }
        if rosName.count > 0 {
            rosName.removeLast()
        }
        return rosName
    }
}
