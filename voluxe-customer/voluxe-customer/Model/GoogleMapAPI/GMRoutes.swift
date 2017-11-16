//
//  GMRoutes.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/16/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import ObjectMapper

class GMRoutes: NSObject, Mappable {
    
    var legs: [GMLegs]?
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        legs = map["legs"].currentValue as? [GMLegs]
    }
    
    func mapping(map: Map) {
        legs <- map["legs"]
    }
}
