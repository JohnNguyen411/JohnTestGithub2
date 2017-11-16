//
//  GMTextValueObject.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/16/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import ObjectMapper

class GMTextValueObject: NSObject, Mappable {
    
    var text: String?
    var value: Int64?
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        text = map["text"].currentValue as? String
        value = map["value"].currentValue as? Int64
    }
    
    func mapping(map: Map) {
        text <- map["text"]
        value <- map["value"]
    }
}
