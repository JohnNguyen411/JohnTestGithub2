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
        AdminAPI.login(email: "bot@luxe.com",
                       password: "botbotbot",
                       requestVerificationCodeFor: customerEmail,
                       completion: completion)
    }
}
