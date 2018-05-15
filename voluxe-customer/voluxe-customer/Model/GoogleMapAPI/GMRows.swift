//
//  GMRows.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 5/4/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import ObjectMapper

class GMRows: Mappable {
    
    var elements: [GMElements]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        elements <- map["elements"]
    }
    
}
