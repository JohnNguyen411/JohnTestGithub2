//
//  ServiceGroup.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 2/2/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class ServiceGroup: Object, Mappable {
    
    var name: String?
    var services: [Service]?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    convenience init(name: String?, services: [Service]?) {
        self.init()
        self.name = name
        self.services = services
    }
    
    
    func mapping(map: Map) {
        name <- map["name"]
        services <- map["services"]
    }
    
}
