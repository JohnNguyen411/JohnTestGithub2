//
//  Driver.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/15/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

@objcMembers public class Driver: NSObject, Codable {
    
    public dynamic var id: Int = -1
    public dynamic var name: String?
    public dynamic var iconUrl: String?
    public dynamic var location: Location?
    
    // Driver fields
    public dynamic var email: String?
    public dynamic var firstName: String?
    public dynamic var lastName: String?
    public dynamic var languageCode: String?
    public dynamic var passwordResetRequired: Bool?
    public dynamic var lastLoginAt: Date?  // might be null
    public dynamic var workPhoneNumber: String?
    public dynamic var workPhoneNumberVerified: Bool?
    public dynamic var personalPhoneNumber: String?
    public dynamic var personalPhoneNumberVerified: Bool?
    public dynamic var photoUrl: String? // might be null
    public dynamic var type: String?
    public dynamic var enabled: Bool?
    
    
    private enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case photoUrl = "photo_url"
        case location
        
        // Driver fields
        case email
        case languageCode = "language_code"
        case passwordResetRequired = "password_reset_required"
        case lastLoginAt = "last_login_at"
        case workPhoneNumber = "work_phone_number"
        case workPhoneNumberVerified = "work_phone_number_verified"
        case personalPhoneNumber = "personal_phone_number"
        case personalPhoneNumberVerified = "personal_phone_number_verified"
        case type
        case enabled
    }
    
    
    // Driver Function
    func readyForUse() -> Bool {
        if let passwordResetRequired = self.passwordResetRequired, passwordResetRequired {
            return false
        }
        if let workPhoneNumberVerified = self.workPhoneNumberVerified, !workPhoneNumberVerified {
            return false
        }
        if photoUrl == nil || photoUrl?.count == 0 {
            return false
        }
        return true
    }
   
}
