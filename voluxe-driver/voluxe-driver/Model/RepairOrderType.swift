//
//  RepairOrderType.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 1/23/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation

struct RepairOrderType: Codable {
    
    let id: Int
    let name: String?
    let description: String?
    let category: String?
    let createdAt: Date?
    let updatedAt: Date?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case category
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
}
