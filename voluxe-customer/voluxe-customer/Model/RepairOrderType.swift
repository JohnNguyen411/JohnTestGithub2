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
    
    var id: Int = -1
    var name: String?
    var desc: String = ""
    var category: String?
    var createdAt: Date?
    var updatedAt: Date?
    
    /*
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        desc <- map["description"]
        category <- map["category"]
        createdAt <- (map["created_at"], VLISODateTransform())
        updatedAt <- (map["updated_at"], VLISODateTransform())
    }
    */
    
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
