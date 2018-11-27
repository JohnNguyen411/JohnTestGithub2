//
//  VehicleInspection.swift
//  voluxe-driver
//
//  Created by Christoph on 10/24/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation

// TODO can this be simplified into a re-usable class
// document inspection as a requestId
// vehicle inspection has a vehicleId
// loander inspection probably has a loaner vehicle id
struct Inspection: Codable {

    let id: Int
    let requestId: Int?
    let vehicleId: Int?
    let notes: String?

    enum CodingKeys: String, CodingKey {
        case id
        case requestId = "request_id"
        case vehicleId = "vehicle_id"
        case notes
    }
}
