//
//  Driver.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/15/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class Driver: Object, Codable {
    
    dynamic var id: Int = -1
    dynamic var name: String?
    dynamic var iconUrl: String?
    dynamic var location: Location?
    
/*
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["first_name"]
        iconUrl <- map["photo_url"]
        location <- map["location"]
    }
 */
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
