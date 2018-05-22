//
//  User.swift
//  voluxe-customer
//
//  Created by Christoph on 5/17/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import ObjectMapper

class User: Mappable {

    @objc dynamic var id: Int = -1
    @objc dynamic var enabled: Bool = true
    @objc dynamic var languageCode: String?
    @objc dynamic var passwordResetRequired: Bool = false
    @objc dynamic var photoUrl: String?
    @objc dynamic var email: String?
    @objc dynamic var firstName: String?
    @objc dynamic var lastName: String?
    @objc dynamic var createdAt: Date?
    @objc dynamic var updatedAt: Date?

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        id <- map["id"]
        enabled <- map["enabled"]
        createdAt <- (map["created_at"], VLISODateTransform())
        updatedAt <- (map["updated_at"], VLISODateTransform())
        languageCode <- map["language_code"]
        passwordResetRequired <- map["password_reset_required"]
        photoUrl <- map["photo_url"]
        email <- map["email"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
    }
}
