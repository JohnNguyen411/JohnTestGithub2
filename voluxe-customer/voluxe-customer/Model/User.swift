//
//  User.swift
//  hse
//
//  Created by Henrik Roslund on 08/06/16.
//  Copyright © 2016 Volvo. All rights reserved.
//

import Foundation
import ObjectMapper

class User: Mappable {

    var name: String!
    var phone: String!
    var email: String!
    var unsupported: [Vehicle] = []
    var vehicles: [Vehicle] = []

    init() {}

    init(name: String, phone: String, email: String, vehicles: [Vehicle], unsupported: [Vehicle]) {
        self.name = name
        self.phone = phone
        self.email = email
        self.vehicles = vehicles
        self.unsupported = unsupported
    }

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        name <- map["name"]
        phone <- map["phone"]
        email <- map["email"]
        vehicles <- map["vehicles"]
        unsupported <- map["unsupported"]
    }
}
