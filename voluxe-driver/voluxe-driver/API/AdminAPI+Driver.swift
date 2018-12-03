//
//  AdminAPI+Driver.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 11/15/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation

extension AdminAPI {
    
    static func verificationCode(for driver: Driver,
                                 completion: @escaping ((String?, LuxeAPIError.Code?) -> Void))
    {
        let route = "v1/phone-verification-codes"
        let parameters: RestAPIParameters = ["user_id": "\(driver.id)",
            "phone_number": driver.workPhoneNumber]
        self.api.get(route: route, queryParameters: parameters) {
            response in
            completion(response?.asVerificationCodeString(), response?.asErrorCode())
        }
    }
    
}
