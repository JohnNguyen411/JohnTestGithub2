//
//  Customer.swift
//  hse
//
//  Created by Kimmo Lahdenkangas on 05/04/16.
//  Copyright © 2016 Volvo. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreLocation
import RealmSwift

class Customer: Object, Mappable {

    @objc dynamic var id: Int = -1
    @objc dynamic var volvoCustomerId: String?
    @objc dynamic var email: String?
    @objc dynamic var firstName: String?
    @objc dynamic var lastName: String?
    @objc dynamic var marketCode: String?
    @objc dynamic var phoneNumber: String?
    @objc dynamic var phoneNumberVerified: Bool = false
    @objc dynamic var credit: Int = 0
    @objc dynamic var currencyId: Int = 0
    @objc dynamic var photoUrl: String?
    @objc dynamic var enabled: Bool = true
    @objc dynamic var location: Location?
    @objc dynamic var createdAt: Date?
    @objc dynamic var updatedAt: Date?

    required convenience init?(map: Map) {
        self.init()
    }
   
    func mapping(map: Map) {
        id <- map["id"]
        volvoCustomerId <- map["volvo_customer_id"]
        email <- map["email"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        marketCode <- map["market_code"]
        phoneNumber <- map["phone_number"]
        phoneNumberVerified <- map["phone_number_verified"]
        credit <- map["credit"]
        currencyId <- map["currency_id"]
        photoUrl <- map["photo_url"]
        location <- map["location"]
        enabled <- map["enabled"]
        createdAt <- (map["created_at"], VLISODateTransform())
        updatedAt <- (map["updated_at"], VLISODateTransform())
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

