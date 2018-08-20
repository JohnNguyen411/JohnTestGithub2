//
//  AdminAPI+Test.swift
//  voluxe-customerUITests
//
//  Created by Christoph on 5/17/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

extension AdminAPI {

    static func loginAndRequestVerificationCode(for customerEmail: String,
                                                completion: @escaping ((VerificationCode?) -> ()))
    {
        // note that the email and password are for the admin user
        // to get access to the admin API and is not the customer user
        AdminAPI.login(email: "bots@luxe.com",
                       password: "1234qwer",
                       requestVerificationCodeFor: customerEmail,
                       completion: completion)
    }
}
