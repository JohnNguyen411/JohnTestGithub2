//
//  BotUser.swift
//  voluxe-customerUITests
//
//  Created by Christoph on 5/21/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

/**
 State suitable for use with an automated test.  Using static fields that are created
 when the test is launched allows the same state to be used across the test instance.
 Of course this won't work if two different test users need to be managed, but for the
 moment this works well for single user testing.

 This class should NEVER be serialized or logged since it will be an authenticated
 username and password.  It only provides a convenience to allow multiple test
 functions to share the same state for input.
 */
class BotUserData {

    static let firstName = "Luxe"
    static let lastName = "Bot"
    static let email = String.uniqueEmailString()
    static let phone = String.uniquePhoneNumberString()
    static let password = String.uniquePassword()
}
