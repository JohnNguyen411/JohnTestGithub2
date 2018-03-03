//
//  ContactDriver.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 2/26/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import ObjectMapper

class ContactDriver: NSObject, Mappable {
    
    var driver: Driver?
    var textPhoneNumber: String?
    var voicePhoneNumber: String?
    var bodyHeader: String?

    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        driver <- map["recipient"]
        textPhoneNumber <- map["text_messages.phone_number"]
        voicePhoneNumber <- map["text_messages.phone_number"]
        bodyHeader <- map["text_messages.bodyHeader"]
    }
    
}