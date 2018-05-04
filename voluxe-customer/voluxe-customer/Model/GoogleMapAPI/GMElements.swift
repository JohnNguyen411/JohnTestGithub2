//
//  GMElements.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 5/4/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import ObjectMapper

class GMElements: NSObject, Mappable {
    
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
