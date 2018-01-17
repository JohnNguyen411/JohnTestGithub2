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
    
    /*
 
 "data": {
 "id": "ec22032b-5563-4c21-a8c6-9535b66ac514",
 "value": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImVjMjIwMzJiLTU1NjMtNGMyMS1hOGM2LTk1MzViNjZhYzUxNCIsImRhdGEiOnsidXNlcl9pZCI6MTcsInVzZXJfdHlwZSI6ImN1c3RvbWVyIn0sImlhdCI6MTUxNjIxODExNywiZXhwIjoxNTE4ODEwMTE3fQ.A_VGB_NzvBYthwzlKzrGQlM5OfaLv9RqO1cesDF7m24",
 "issued_at": "2018-01-17T19:41:57.000Z",
 "expires_at": "2018-02-16T19:41:57.000Z",
 "data": {
 "user_id": 17,
 "user_type": "customer"
 }
 },
 "meta": {
 "request_id": "d1b9d270-5bdb-4067-b292-6518e9e97a8c"
 }
 */
}
