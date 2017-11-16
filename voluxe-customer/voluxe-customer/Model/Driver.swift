//
//  Driver.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/15/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import ObjectMapper

class Driver: NSObject, Mappable {
    
    var id: Int64?
    var name: String?
    var iconUrl: String?
    var phone: String?
    var email: String!
    
    override init() {
        super.init()
    }
    
    init(id: Int64, name: String?, iconUrl: String, phone: String?, email: String) {
        self.id = id
        self.name = name
        self.iconUrl = iconUrl
        self.phone = phone
        self.email = email
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        iconUrl <- map["iconUrl"]
        phone <- map["phone"]
        email <- map["email"]
    }
}
