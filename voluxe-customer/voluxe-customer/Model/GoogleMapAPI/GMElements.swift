//
//  GMElements.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 5/4/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import ObjectMapper

class GMElements: Mappable {
    
    var distance: GMTextValueObject?
    var duration: GMTextValueObject?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        distance <- map["distance"]
        duration <- map["duration"]
    }
}
