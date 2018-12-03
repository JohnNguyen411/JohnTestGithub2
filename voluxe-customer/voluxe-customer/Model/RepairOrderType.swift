//
//  RepairOrderType.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 3/16/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class RepairOrderType: Object, Codable {
    
    dynamic var id: Int = -1
    dynamic var name: String?
    dynamic var desc: String = ""
    dynamic var category: String?
    dynamic var createdAt: Date?
    dynamic var updatedAt: Date?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case desc = "description"
        case category
        case createdAt = "created_at" 
        case updatedAt = "updated_at" 
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
 
    func getCategory() -> RepairOrderCategory {
        if let category = category {
            return RepairOrderCategory(rawValue: category)!
        }
        return .other
    }
 
    static func categoryName(category: RepairOrderCategory) -> String {
        if category == .routineMaintenanceByDistance {
            return .MilestoneServices
        }
        return .OtherMaintenanceRepairs
    }
    
}

public enum RepairOrderCategory: String {
    case routineMaintenanceByDistance = "routine_maintenance_by_distance"
    case other = "other"
    case custom = "custom"
}
