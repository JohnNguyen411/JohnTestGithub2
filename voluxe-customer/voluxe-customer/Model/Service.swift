//
//  Service.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/17/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import ObjectMapper

class Service: NSObject, Mappable {
    
    var name: String?
    var price: Double?
    
    override init() {
        super.init()
    }
    
    init(name: String?, price: Double?) {
        self.name = name
        self.price = price
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        price <- map["price"]
    }
    
}
