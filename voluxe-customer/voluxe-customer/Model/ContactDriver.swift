//
//  ContactDriver.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 2/26/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
class ContactDriver: Codable {
    
    var driver: Driver?
    var textPhoneNumber: String?
    var voicePhoneNumber: String?
    var bodyHeader: String?
    
    /*
    func mapping(map: Map) {
        driver <- map["recipient"]
        textPhoneNumber <- map["text_messages.phone_number"]
        voicePhoneNumber <- map["voice_calls.phone_number"]
        bodyHeader <- map["text_messages.bodyHeader"]
    }
 */
    
}
