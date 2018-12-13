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

enum InspectionType: Int, CaseIterable, CustomStringConvertible {

    case document = 0
    case vehicle
    case loaner
    case unknown

    var description: String {
        switch self {
            case .document: return "Document"
            case .loaner: return "Loaner"
            case .vehicle: return "Vehicle"
            case .unknown: return "Unspecified"
        }
    }
}
