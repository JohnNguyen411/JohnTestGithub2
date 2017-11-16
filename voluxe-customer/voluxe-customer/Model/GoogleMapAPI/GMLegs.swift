//
//  GMLegs.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/16/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import ObjectMapper

class GMLegs: NSObject, Mappable {
    
    var distance: GMTextValueObject?
    var duration: GMTextValueObject?
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        distance = map["distance"].currentValue as? GMTextValueObject
        duration = map["duration"].currentValue as? GMTextValueObject
    }
    
    func mapping(map: Map) {
        distance <- map["distance"]
        duration <- map["duration"]
    }
}
