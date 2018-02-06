//
//  Service.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/17/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Service: Object, Mappable {

    var name: String?
    var price: Double?
    var serviceDescription: String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    convenience init(name: String?, price: Double?) {
        self.init()
        self.name = name
        self.price = price
    }
 
    
    func mapping(map: Map) {
        name <- map["name"]
        price <- map["price"]
        serviceDescription <- map["description"]
    }
    
}
