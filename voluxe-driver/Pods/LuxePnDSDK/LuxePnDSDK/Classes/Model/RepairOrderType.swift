//
//  RepairOrderType.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 3/16/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

@objcMembers public class RepairOrderType: NSObject, Codable {
    
    public dynamic var id: Int = -1
    public dynamic var name: String?
    public dynamic var desc: String = ""
    public dynamic var category: String?
    public dynamic var createdAt: Date?
    public dynamic var updatedAt: Date?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case desc = "description"
        case category
        case createdAt = "created_at" 
        case updatedAt = "updated_at" 
    }
    
    public func getCategory() -> RepairOrderCategory {
        if let category = category {
            return RepairOrderCategory(rawValue: category)!
        }
        return .other
    }
 
}

public enum RepairOrderCategory: String {
    case routineMaintenanceByDistance = "routine_maintenance_by_distance"
    case other = "other"
    case custom = "custom"
}
