//
//  CustomerAPI+Account.swift
//  voluxe-customer
//
//  Created by Christoph on 5/17/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper
import BrightFutures
import Foundation

extension CustomerAPI {

    /**
     Endpoint to update Customer's phone number
     - parameter customerId: Customer's ID
     - parameter phoneNumber: The new customer Phone Number

     - Returns: A Future ResponseObject containing a Customer Object, or an AFError if an error occured
     */
    func updatePhoneNumber(customerId: Int, phoneNumber: String) -> Future<ResponseObject<EmptyMappableObject>?, Errors> {
        let promise = Promise<ResponseObject<EmptyMappableObject>?, Errors>()

        let params: Parameters = [
            "phone_number": phoneNumber
        ]

        NetworkRequest.request(url: "/v1/customers/\(customerId)", method: .patch, queryParameters: nil, bodyParameters: params, withBearer: true).responseJSON { response in

            let responseObject = ResponseObject<EmptyMappableObject>(json: response.result.value)

            if response.error == nil && responseObject.error == nil {
                promise.success(responseObject)
            } else {
                promise.failure(Errors(dataResponse: response, apiError: responseObject.error))
            }
        }
        return promise.future
    }

    /**
     Endpoint to initiate Customer's reset password
     - parameter customerId: Customer's ID

     - Returns: A Future ResponseObject containing an empty Object, or an AFError if an error occured
     */
    func requestPasswordChange(customerId: Int) -> Future<ResponseObject<EmptyMappableObject>?, Errors> {
        let promise = Promise<ResponseObject<EmptyMappableObject>?, Errors>()

        NetworkRequest.request(url: "/v1/customers/\(customerId)/password/request-change", method: .put, queryParameters: nil, withBearer: true).responseJSONErrorCheck { response in

            let responseObject = ResponseObject<EmptyMappableObject>(json: response.result.value)

            if response.error == nil && responseObject.error == nil {
                promise.success(responseObject)
            } else {
                promise.failure(Errors(dataResponse: response, apiError: responseObject.error))
            }
        }
        return promise.future
    }

    /**
     Endpoint to reset Customer's password
     - parameter customerId: Customer's ID
     - parameter code: The verification code the customer received
     - parameter password: The new password

     - Returns: A Future ResponseObject containing an empty Object, or an AFError if an error occured
     */
    func passwordChange(customerId: Int, code: String, password: String) -> Future<ResponseObject<EmptyMappableObject>?, Errors> {
        let promise = Promise<ResponseObject<EmptyMappableObject>?, Errors>()

        let params: Parameters = [
            "verification_code": code,
            "password": password
        ]

        NetworkRequest.request(url: "/v1/customers/\(customerId)/password/change", method: .put, queryParameters: nil, bodyParameters: params, withBearer: true).responseJSONErrorCheck { response in

            let responseObject = ResponseObject<EmptyMappableObject>(json: response.result.value)

            if response.error == nil && responseObject.error == nil {
                promise.success(responseObject)
            } else {
                promise.failure(Errors(dataResponse: response, apiError: responseObject.error))
            }
        }
        return promise.future
    }

    /**
     Endpoint to initiate Customer's reset password from phone number
     - parameter phoneNumber: Customer's phone number

     - Returns: A Future ResponseObject containing an empty Object, or an AFError if an error occured
     */
    func passwordReset(phoneNumber: String) -> Future<ResponseObject<EmptyMappableObject>?, Errors> {
        let promise = Promise<ResponseObject<EmptyMappableObject>?, Errors>()

        let params: Parameters = [
            "phone_number": phoneNumber
        ]

        NetworkRequest.request(url: "/v1/customers/password-reset/request", method: .put, queryParameters: nil, bodyParameters: params,  withBearer: true).responseJSONErrorCheck { response in

            let responseObject = ResponseObject<EmptyMappableObject>(json: response.result.value)

            if response.error == nil && responseObject.error == nil {
                promise.success(responseObject)
            } else {
                promise.failure(Errors(dataResponse: response, apiError: responseObject.error))
            }
        }
        return promise.future
    }

    /**
     Endpoint to set a new password for the customer using a 2FA verification code.
     - parameter phoneNumber: Customer's phone number
     - parameter code: The verification code the customer received
     - parameter password: The new password

     - Returns: A Future ResponseObject containing an empty Object, or an AFError if an error occured
     */
    func passwordResetConfirm(phoneNumber: String, code: String, password: String) -> Future<ResponseObject<EmptyMappableObject>?, Errors> {
        let promise = Promise<ResponseObject<EmptyMappableObject>?, Errors>()

        let params: Parameters = [
            "phone_number": phoneNumber,
            "verification_code": code,
            "password": password
        ]

        NetworkRequest.request(url: "/v1/customers/password-reset/confirm", method: .put, queryParameters: nil, bodyParameters: params, withBearer: true).responseJSONErrorCheck { response in

            let responseObject = ResponseObject<EmptyMappableObject>(json: response.result.value)

            if response.error == nil && responseObject.error == nil {
                promise.success(responseObject)
            } else {
                promise.failure(Errors(dataResponse: response, apiError: responseObject.error))
            }
        }
        return promise.future
    }

    /**
     Get the Customer object with a customerId
     - parameter id: Customer's Id

     - Returns: A Future ResponseObject containing a Customer Object, or an AFError if an error occured
     */
    func getCustomer(id: Int) -> Future<ResponseObject<MappableDataObject<Customer>>?, Errors> {
        let promise = Promise<ResponseObject<MappableDataObject<Customer>>?, Errors>()

        NetworkRequest.request(url: "/v1/customers/\(id)", queryParameters: [:], withBearer: true).responseJSONErrorCheck { response in
            var responseObject: ResponseObject<MappableDataObject<Customer>>?

            if let json = response.result.value as? [String: Any] {
                responseObject = ResponseObject<MappableDataObject<Customer>>(json: json, allowEmptyData: false)
            }

            if response.error == nil && responseObject?.error == nil {
                promise.success(responseObject)
            } else {
                promise.failure(Errors(dataResponse: response, apiError: responseObject?.error))
            }
        }
        return promise.future
    }

    /**
     Get the Customer object for the logged user

     - Returns: A Future ResponseObject containing a Customer Object, or an AFError if an error occured
     */
    func getMe() -> Future<ResponseObject<MappableDataObject<Customer>>?, Errors> {
        let promise = Promise<ResponseObject<MappableDataObject<Customer>>?, Errors>()

        NetworkRequest.request(url: "/v1/users/me", queryParameters: [:], withBearer: true).responseJSONErrorCheck { response in

            let responseObject = ResponseObject<MappableDataObject<Customer>>(json: response.result.value, allowEmptyData: false)

            if response.error == nil && responseObject.error == nil {
                promise.success(responseObject)
            } else {
                promise.failure(Errors(dataResponse: response, apiError: responseObject.error))
            }

        }
        return promise.future
    }

    /**
     Add new vehicle to Customer
     - parameter customerId: Customer's Id
     - parameter deviceToken: Device token for push notifs

     - Returns: A Future ResponseObject containing an empty data response, or an AFError if an error occured
     */
    func registerDevice(customerId: Int, deviceToken: String) -> Future<ResponseObject<EmptyMappableObject>?, Errors> {
        let promise = Promise<ResponseObject<EmptyMappableObject>?, Errors>()

        var uuid = ""
        if let deviceId = KeychainManager.sharedInstance.deviceId {
            uuid = deviceId
        }

        let params: Parameters = [
            "os": "ios",
            "os_version": UIDevice.current.systemVersion,
            "unique_identifier": uuid,
            "address": deviceToken
        ]

        NetworkRequest.request(url: "/v1/customers/\(customerId)/devices/current", method: .put, queryParameters: nil, bodyParameters: params, withBearer: true).responseJSONErrorCheck { response in

            let responseObject = ResponseObject<EmptyMappableObject>(json: response.result.value)

            if response.error == nil && responseObject.error == nil {
                promise.success(responseObject)
            } else {
                promise.failure(Errors(dataResponse: response, apiError: responseObject.error))
            }
        }
        return promise.future
    }
}
