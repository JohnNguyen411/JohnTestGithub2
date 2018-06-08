//
//  CustomerAddress.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 2/9/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreLocation
import RealmSwift

class CustomerAddress: Object, Mappable {
    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var volvoCustomerId: String?
    @objc dynamic var location: Location?
    @objc dynamic var label: String? // Work / Home / Gym etc
    @objc dynamic var createdAt: Date?
    @objc dynamic var updatedAt: Date?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    convenience init(id: String?) {
        self.init()
        if let id = id {
            self.id = id
        }
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        volvoCustomerId <- map["volvo_customer_id"]
        location <- map["location"]
        label <- map["label"]
        createdAt <- (map["created_at"], VLISODateTransform())
        updatedAt <- (map["updated_at"], VLISODateTransform())
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

