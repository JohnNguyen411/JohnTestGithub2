//
//  Customer.swift
//  hse
//
//  Created by Kimmo Lahdenkangas on 05/04/16.
//  Copyright © 2016 Volvo. All rights reserved.
//

import Foundation
import CoreLocation
import RealmSwift

@objcMembers class Customer: Object, Codable {

    var id: Int = -1
    var volvoCustomerId: String?
    var email: String?
    var firstName: String?
    var lastName: String?
    var marketCode: String?
    var phoneNumber: String?
    var phoneNumberVerified: Bool = false
    var passwordResetRequired: Bool = false
    var credit: Int?
    var currencyId: Int?
    var photoUrl: String?
    var enabled: Bool = true
    var location: Location?
    var createdAt: Date?
    var updatedAt: Date?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case volvoCustomerId = "volvo_customer_id"
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case marketCode = "market_code"
        case phoneNumber = "phone_number"
        case phoneNumberVerified = "phone_number_verified"
        case passwordResetRequired = "password_reset_required"
        case credit
        case currencyId = "currency_id"
        case photoUrl = "photo_url"
        case location
        case enabled
        case createdAt = "created_at" //TODO: VLISODateTransform?
        case updatedAt = "updated_at" //TODO: VLISODateTransform?
    }
   
    /*
 
     keyNotFound(CodingKeys(stringValue: "credit", intValue: nil), Swift.DecodingError.Context(codingPath: [CodingKeys(stringValue: "data", intValue: nil)], debugDescription: "No value associated with key CodingKeys(stringValue: \"credit\", intValue: nil) (\"credit\").", underlyingError: nil))
     
 {"data":{"id":30,"email":"johan@luxe.com","first_name":"Johan","last_name":"Giroux","language_code":"EN","password_reset_required":false,"last_login_at":"2018-11-16T23:05:10.901Z","photo_url":"https://d3061ukarzgnuk.cloudfront.net/drivers/30/photos/a9bf077c-9929-49da-a39e-82bfcdc1d230.jpg","enabled":true,"phone_number":"+16282244571","phone_number_verified":true,"type":"customer"},"meta":{"request_id":"4ca563f4-4e95-4913-9dd9-c7fa17dc6439"}}
 
 */
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
