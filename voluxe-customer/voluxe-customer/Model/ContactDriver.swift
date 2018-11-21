//
//  ContactDriver.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 2/26/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

struct ContactDriver: Codable {
    
    var driver: Driver?
    var textPhoneNumber: String?
    var voicePhoneNumber: String?
    var bodyHeader: String?
    
    
    private enum CodingKeys: String, CodingKey {
        case driver = "recipient"
        case textMessages = "text_messages"
        case voiceCalls = "voice_calls"
        case phoneNumber = "phone_number"
        case bodyHeader = "bodyHeader"
    }
    
   
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.driver = try container.decodeIfPresent(Driver.self, forKey: .driver)
        
        if let textMessages = try? container.nestedContainer(keyedBy: CodingKeys.self, forKey: .textMessages) {
            self.textPhoneNumber = try textMessages.decodeIfPresent(String.self, forKey: .phoneNumber)
            self.bodyHeader = try textMessages.decodeIfPresent(String.self, forKey: .bodyHeader)
        }

        if let voiceCalls = try? container.nestedContainer(keyedBy: CodingKeys.self, forKey: .voiceCalls) {
            self.voicePhoneNumber = try voiceCalls.decodeIfPresent(String.self, forKey: .phoneNumber)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(driver, forKey: .driver)
        var textMessages = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .textMessages)
        try textMessages.encode(textPhoneNumber, forKey: .phoneNumber)
        var voiceCalls = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .voiceCalls)
        try voiceCalls.encode(voicePhoneNumber, forKey: .phoneNumber)
        
    }
    
}
