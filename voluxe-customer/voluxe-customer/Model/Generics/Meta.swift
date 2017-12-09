//
//  Meta.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 12/7/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import ObjectMapper

class Meta: Mappable {
    
    var limit: Int?
    var offset: Int?
    var count: Int?
    var requestId: String?

    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        limit <- map["limit"]
        offset <- map["offset"]
        count <- map["count"]
        requestId <- map["request_id"]
    }
    
    
}
