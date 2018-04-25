//
//  ForceUpgrade.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 4/25/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class ForceUpgrade: Object, Mappable {
    
    @objc dynamic var buildNumber: Int = -1
    @objc dynamic var createdAt: Date?
    @objc dynamic var updatedAt: Date?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        buildNumber <- map["buildNumber"]
        createdAt <- (map["created_at"], VLISODateTransform())
        updatedAt <- (map["updated_at"], VLISODateTransform())
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
