//
//  Driver.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/15/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Driver: Object, Mappable {
    
    @objc dynamic var id: Int = -1
    @objc dynamic var name: String?
    @objc dynamic var iconUrl: String?
    @objc dynamic var location: Location?

    required convenience init?(map: Map) {
        self.init()
    }
    

    func mapping(map: Map) {
        id <- map["id"]
        name <- map["first_name"]
        iconUrl <- map["photo_url"]
        location <- map["location"]
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
