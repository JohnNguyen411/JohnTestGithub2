//
//  GMRows.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 5/4/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import ObjectMapper

class GMRows: NSObject, Mappable {
    
    var elements: [GMElements]?
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        elements = map["elements"].currentValue as? [GMElements]
    }
    
    func mapping(map: Map) {
        elements <- map["elements"]
    }
    
}
