//
//  VehicleInspection.swift
//  voluxe-driver
//
//  Created by Christoph on 10/24/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation

struct Inspection: Codable {

    let id: Int
    let vehicleId: Int?
    let notes: String?

    enum CodingKeys: String, CodingKey {
        case id
        case vehicleId = "vehicle_id"
        case notes
    }
}
