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
    
    var id: Int = -1
    var make: String?
    var name: String?
    var managed: Bool = true
    var createdAt: Date?
    var updatedAt: Date?
    
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
