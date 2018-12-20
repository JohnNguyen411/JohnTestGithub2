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
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name = "first_name"
        case iconUrl = "photo_url"
        case location
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["location"]
    }
}
