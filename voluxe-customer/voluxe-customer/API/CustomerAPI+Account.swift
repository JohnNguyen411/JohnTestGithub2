//
//  CustomerAPI+Account.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 11/7/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

extension CustomerAPI {
    
    /**
     Endpoint to update Customer's phone number
     - parameter customerId: Customer's ID
     - parameter phoneNumber: The new customer Phone Number
     - parameter completion: A closure which is called with a LuxeAPIError.Code if an error occured
     */
    static func updatePhoneNumber(customerId: Int, phoneNumber: String,
                                  completion: ((LuxeAPIError.Code?) -> ())? = nil) {
        let route = "v1/customers/\(customerId)"
        
        let params = [
            "phone_number": phoneNumber
        ]
        
        self.api.patch(route: route, bodyParameters: params) {
            response in
            completion(response?.asErrorCode())
        }
    }
    
    
    /**
     Endpoint to update Customer's name
     - parameter customerId: Customer's ID
     - parameter firstName: The customer FirstName
     - parameter lastName: The customer LastName
     - parameter completion: A closure which is called with a LuxeAPIError.Code if an error occured
     */
    static func updateName(customerId: Int, firstName: String, lastName: String,
                                  completion: ((LuxeAPIError.Code?) -> ())? = nil) {
        let route = "v1/customers/\(customerId)"
        
        let params = [
            "first_name": firstName,
            "last_name": lastName
        ]
        
        self.api.patch(route: route, bodyParameters: params) {
            response in
            completion(response?.asErrorCode())
        }
    }
    
    /**
     Endpoint to update Customer's email
     - parameter customerId: Customer's ID
     - parameter email: The customer's email
     - parameter completion: A closure which is called with a LuxeAPIError.Code if an error occured
     */
    static func updateEmail(customerId: Int, email: String,
                           completion: ((LuxeAPIError.Code?) -> ())? = nil) {
        let route = "v1/customers/\(customerId)"
        
        let params = [
            "email": email
        ]
        
        self.api.patch(route: route, bodyParameters: params) {
            response in
            completion(response?.asErrorCode())
        }
    }
    
    /**
     Endpoint to initiate Customer's reset password
     - parameter customerId: Customer's ID
     - parameter completion: A closure which is called with a LuxeAPIError.Code if an error occured
     */
    static func requestPasswordChange(customerId: Int,
                            completion: ((LuxeAPIError.Code?) -> ())? = nil) {
        let route = "v1/customers/\(customerId)/password/request-change"
        
        self.api.put(route: route) {
            response in
            completion(response?.asErrorCode())
        }
    }
    
    /**
     Endpoint to reset Customer's password
     - parameter customerId: Customer's ID
     - parameter code: The verification code the customer received
     - parameter password: The new password
     - parameter completion: A closure which is called with a LuxeAPIError.Code if an error occured
     */
    static func passwordChange(customerId: Int, code: String, password: String,
                            completion: ((LuxeAPIError.Code?) -> ())? = nil) {
        let route = "v1/customers/\(customerId)/password/change"
        
        let params = [
            "verification_code": code,
            "password": password
        ]
        
        self.api.put(route: route, bodyParameters: params) {
            response in
            completion(response?.asErrorCode())
        }
    }
    
    /**
     Endpoint to initiate Customer's reset password from phone number
     - parameter phoneNumber: Customer's phone number
     - parameter completion: A closure which is called with a LuxeAPIError.Code if an error occured
     */
    static func passwordReset(phoneNumber: String,
                               completion: ((LuxeAPIError.Code?) -> ())? = nil) {
        let route = "v1/customers/password-reset/request"
        
        let params = [
            "phone_number": phoneNumber
        ]
        
        self.api.put(route: route, bodyParameters: params) {
            response in
            completion(response?.asErrorCode())
        }
    }
    
    /**
     Endpoint to set a new password for the customer using a 2FA verification code.
     - parameter phoneNumber: Customer's phone number
     - parameter code: The verification code the customer received
     - parameter password: The new password
     - parameter completion: A closure which is called with a LuxeAPIError.Code if an error occured
     */
    static func passwordResetConfirm(phoneNumber: String, code: String, password: String,
                              completion: ((LuxeAPIError.Code?) -> ())? = nil) {
        let route = "v1/customers/password-reset/confirm"
        
        let params = [
            "phone_number": phoneNumber,
            "verification_code": code,
            "password": password
        ]
        
        self.api.put(route: route, bodyParameters: params) {
            response in
            completion(response?.asErrorCode())
        }
    }
    
    /**
     Endpoint to set a new password for the customer using a 2FA verification code.
     - parameter phoneNumber: Customer's phone number
     - parameter code: The verification code the customer received
     - parameter password: The new password
     - parameter completion: A closure which is called with a LuxeAPIError.Code if an error occured
     */
    static func passwordResetConfirm(phoneNumber: String, code: String, password: String,
                                     completion: ((LuxeAPIError.Code?) -> ())? = nil) {
        let route = "v1/customers/password-reset/confirm"
        
        let params = [
            "phone_number": phoneNumber,
            "verification_code": code,
            "password": password
        ]
        
        self.api.put(route: route, bodyParameters: params) {
            response in
            completion(response?.asErrorCode())
        }
    }
    
    /**
     Get the Customer object for the logged user
     - parameter completion: A closure which is called with a Customer object or LuxeAPIError.Code if an error occured
     */
    static func me(phoneNumber: String, code: String, password: String,
                                     completion: @escaping ((Customer?, LuxeAPIError.Code?) -> Void)) {
        let route = "v1/users/me"
        
        self.api.get(route: route) {
            response in
            let customer = response?.decodeCustomer() ?? nil
            completion(customer, response?.asErrorCode())
        }
    }
    
    
    /**
     Register device for Customer
     - parameter customerId: Customer's Id
     - parameter deviceToken: Device token for push notifs
     - parameter completion: A closure which is called with a LuxeAPIError.Code if an error occured
     */
    static func registerDevice(phoneNumber: String, code: String, password: String,
                                     completion: ((LuxeAPIError.Code?) -> ())? = nil) {
        let route = "v1/customers/\(customerId)/devices/current"
        
        var uuid = ""
        if let deviceId = KeychainManager.sharedInstance.deviceId {
            uuid = deviceId
        }
        
        let params = [
            "os": "ios",
            "os_version": UIDevice.current.systemVersion,
            "unique_identifier": uuid,
            "address": deviceToken
        ]
        
        self.api.put(route: route, bodyParameters: params) {
            response in
            completion(response?.asErrorCode())
        }
    }
    
}
