//
//  Customer.swift
//  hse
//
//  Created by Kimmo Lahdenkangas on 05/04/16.
//  Copyright © 2016 Volvo. All rights reserved.
//

import Foundation
import ObjectMapper

class Customer: NSObject, Mappable {

    var name: String?
    var phone: String?
    var email: String!

    override init() {
        super.init()
    }

    init(name: String?, phone: String?, email: String) {
        self.name = name
        self.phone = phone
        self.email = email
    }

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        name <- map["name"]
        phone <- map["phone"]
        email <- map["email"]
    }
}
