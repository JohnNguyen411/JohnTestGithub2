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
    var customerId: Int?
    var issuedAt: Date?
    var expiresAt: Date?
    
    init() {}
    
    init(token: String) {
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        token <- map["value"]
        issuedAt <- (map["issued_at"], VLISODateTransform())
        expiresAt <- (map["expires_at"], VLISODateTransform())
        //let data = map.JSON["data"] as! [String: Any]
        customerId <- map["data.user_id"]
    }
}
