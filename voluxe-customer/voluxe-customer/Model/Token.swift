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
    var userType: String?
    
    init() {}
    
    init(token: String) {
    }
    
    required init?(map: Map) {
    }
    
    
    func mapping(map: Map) {
        token <- map["token"]
        issuedAt <- (map["issued_at"], VLISODateTransform())
        expiresAt <- (map["expires_at"], VLISODateTransform())
        //let data = map.JSON["data"] as! [String: Any]
        customerId <- map["user.id"]
        userType <- map["user.type"]
    }
}
