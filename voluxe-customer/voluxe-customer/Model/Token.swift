//
//  Token.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 12/8/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import ObjectMapper

class Token: Mappable {
    
    var token: String!
    
    init() {}
    
    init(token: String) {
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        token <- map["token"]
    }
}
