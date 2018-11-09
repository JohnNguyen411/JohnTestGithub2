//
//  VehicleMake.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 4/6/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class VehicleMake: Object, Codable {
    
    var id: Int = -1
    var name: String?
    var managed: Bool = true
    var createdAt: Date?
    var updatedAt: Date?
    
    /*
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        managed <- map["managed"]
        createdAt <- (map["created_at"], VLISODateTransform())
        updatedAt <- (map["updated_at"], VLISODateTransform())
    }
    */
    override static func primaryKey() -> String? {
        return "id"
    }
}
