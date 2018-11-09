//
//  CustomerAddress.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 2/9/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import CoreLocation
import RealmSwift

@objcMembers class CustomerAddress: Object, Codable {
    
    var id = UUID().uuidString
    var volvoCustomerId: String?
    var location: Location?
    var label: String? // Work / Home / Gym etc
    var createdAt: Date?
    var updatedAt: Date?
    var luxeCustomerId: Int = -1
    
    
    convenience init(id: String?) {
        self.init()
        if let id = id {
            self.id = id
        }
    }
    /*
    func mapping(map: Map) {
        id <- map["id"]
        volvoCustomerId <- map["volvo_customer_id"]
        location <- map["location"]
        label <- map["label"]
        createdAt <- (map["created_at"], VLISODateTransform())
        updatedAt <- (map["updated_at"], VLISODateTransform())
        luxeCustomerId <- map["customer_id"]
    }
    */
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

