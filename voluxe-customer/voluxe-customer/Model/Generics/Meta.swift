//
//  Meta.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 12/7/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class Meta: Codable {
    
    var limit: Int?
    var offset: Int?
    var count: Int?
    var requestId: String?

    /*
    
    func mapping(map: Map) {
        limit <- map["limit"]
        offset <- map["offset"]
        count <- map["count"]
        requestId <- map["request_id"]
    }
    */
    
}
