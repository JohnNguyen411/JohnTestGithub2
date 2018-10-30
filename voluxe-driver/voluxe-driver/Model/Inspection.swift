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
    let vehicle_id: Int?
    let notes: String?
    let created_at: String  // TODO need date
    let updated_at: String  // TODO need date
}
