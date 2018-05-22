//
//  VerificationCode.swift
//  voluxe-customerUITests
//
//  Created by Christoph on 5/17/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import ObjectMapper

class VerificationCode: Mappable {

    @objc dynamic var id: Int = -1
    @objc dynamic var value: String?
    @objc dynamic var phoneNumber: String?
    @objc dynamic var userId: Int = -1
    @objc dynamic var usedAt: Date?
    @objc dynamic var expiresAt: Date?
    @objc dynamic var createdAt: Date?
    @objc dynamic var updatedAt: Date?

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        id <- map["id"]
        value <- map["value"]
        phoneNumber <- map["phone_number"]
        userId <- map["user_id"]
        usedAt <- (map["used_at"], VLISODateTransform())
        expiresAt <- (map["expires_at"], VLISODateTransform())
        createdAt <- (map["created_at"], VLISODateTransform())
        updatedAt <- (map["updated_at"], VLISODateTransform())
    }
}
