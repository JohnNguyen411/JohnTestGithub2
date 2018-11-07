//
//  CustomerAPI+Signup.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 11/6/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

extension CustomerAPI {
    
    /**
     Signup endpoint for Customer
     - parameter email: Customer's email
     - parameter phoneNumber: Customer's phoneNumber
     - parameter firstName: Customer's firstname
     - parameter lastName: Customer's lastame
     - parameter languageCode: Customer's ISO_639-3 language code
     - parameter completion: A closure which is called with a Customer Object or LuxeAPIError.Code if an error occured
     */
    static func signup(email: String, phoneNumber: String, firstName: String, lastName: String, languageCode: String,
                      completion: @escaping ((Customer?, LuxeAPIError.Code?) -> Void)) {
        let route = "v1/customers/signup"
        
        let params = [
            "email": email,
            "phone_number": phoneNumber,
            "first_name": firstName,
            "last_name": lastName,
            "language_code": languageCode
        ]
        
        self.api.post(route: route, bodyParameters: params) {
            response in
            let customer = response?.decodeCustomer() ?? nil
            completion(customer, response?.asErrorCode())
        }
    }
    
    /**
     Signup confirmation endpoint for Customer
     - parameter email: Customer's email
     - parameter password: Customer's password
     - parameter verificationCode: Customer's SMS verification code
     - parameter completion: A closure which is called with a Customer Object or LuxeAPIError.Code if an error occured
     */
    static func confirmSignup(email: String, password: String, verificationCode: String,
                       completion: @escaping ((Customer?, LuxeAPIError.Code?) -> Void)) {
        let route = "v1/customers/signup/confirm"
        
        let params = [
            "email": email,
            "password": password,
            "verification_code": verificationCode
        ]
        
        self.api.post(route: route, bodyParameters: params) {
            response in
            let customer = response?.decodeCustomer() ?? nil
            completion(customer, response?.asErrorCode())
        }
    }
    
    /**
     Endpoint to request Customer's phone number verification code
     - parameter customerId: Customer's ID
     - parameter completion: A closure which is called with a Customer Object or LuxeAPIError.Code if an error occured
     */
    static func requestPhoneVerificationCode(customerId: Int,
                              completion: ((LuxeAPIError.Code?) -> ())? = nil) {
        let route = "v1/customers/\(customerId)/phone-number/request-verification"
        
        self.api.put(route: route) {
            response in
            completion?(response?.asErrorCode())
        }
    }
    
    /**
     Endpoint to verify Customer's phone number
     - parameter customerId: Customer's ID
     - parameter verificationCode: Verification Code sent by SMS
     - parameter completion: A closure which is called with a LuxeAPIError.Code if an error occured
     */
    static func verifyPhoneNumber(customerId: Int, verificationCode: String,
                                             completion: ((LuxeAPIError.Code?) -> ())? = nil) {
        let route = "v1/customers/\(customerId)/phone-number/verify"
        
        let params = [
            "verification_code": verificationCode
        ]
        
        self.api.put(route: route, bodyParameters: params) {
            response in
            completion?(response?.asErrorCode())
        }
    }
   
}


fileprivate extension RestAPIResponse {
    
    private struct CustomerResponse: Codable {
        let data: Customer
    }
    
    func decodeCustomer() -> Customer? {
        let customer: CustomerResponse? = self.decode()
        return customer?.data
    }
}

