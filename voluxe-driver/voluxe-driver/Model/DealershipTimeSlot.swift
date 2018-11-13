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
    let dealership_id: Int
    let type: String
    let from: Date
    let to: Date
    let available_loaner_vehicle_count: Int?
    let available_assignment_count: Int?
}
