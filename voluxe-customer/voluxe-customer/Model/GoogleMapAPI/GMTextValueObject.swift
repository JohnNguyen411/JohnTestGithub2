//
//  GMTextValueObject.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/16/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import ObjectMapper

class GMTextValueObject: Mappable {
    
    var text: String?
    var value: Int?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        text <- map["text"]
        value <- map["value"]
    }
}
