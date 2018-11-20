//
//  VehicleModel.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 3/1/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class VehicleModel: Object, Codable {
    
    dynamic var id: Int = -1
    dynamic var make: String?
    dynamic var name: String?
    dynamic var managed: Bool = true
    dynamic var createdAt: Date?
    dynamic var updatedAt: Date?
    
    convenience init(make: String, model: String) {
        self.init()
        self.make = make
        self.name = model
    }
    /*
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        make <- map["make"]
        managed <- map["managed"]
        createdAt <- (map["created_at"], VLISODateTransform())
        updatedAt <- (map["updated_at"], VLISODateTransform())
    }
    */
    override static func primaryKey() -> String? {
        return "id"
    }
}
