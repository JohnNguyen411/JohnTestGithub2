//
//  DealershipRepairOrder.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 1/23/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation

struct DealershipRepairOrder: Codable {

    let id: Int
    let dealershipId: Int
    let repairOrderTypeId: Int
    let enabled: Bool?
    let repairOrderType: RepairOrderType
    let createdAt: Date?
    let updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case dealershipId = "dealership_id"
        case repairOrderTypeId = "repair_order_type_id"
        case repairOrderType = "repair_order_type"
        case enabled
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    

}
