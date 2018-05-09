//
//  VehicleModel.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 3/1/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class VehicleModel: Object, Mappable {
    
    @objc dynamic var id: Int = -1
    @objc dynamic var make: String?
    @objc dynamic var name: String?
    @objc dynamic var managed: Bool = true
    @objc dynamic var createdAt: Date?
    @objc dynamic var updatedAt: Date?
    
    convenience init(make: String, model: String) {
        self.init()
        self.make = make
        self.name = model
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        make <- map["make"]
        managed <- map["managed"]
        createdAt <- (map["created_at"], VLISODateTransform())
        updatedAt <- (map["updated_at"], VLISODateTransform())
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
