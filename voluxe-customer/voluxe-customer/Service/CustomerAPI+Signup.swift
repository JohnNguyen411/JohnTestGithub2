//
//  CustomerAPI+Signup.swift
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
     Signup endpoint for Customer
     - parameter email: Customer's email
     - parameter phoneNumber: Customer's phoneNumber
     - parameter firstName: Customer's firstname
     - parameter lastName: Customer's lastame
     - parameter languageCode: Customer's ISO_639-3 language code

     - Returns: A Future ResponseObject containing a Customer Object, or an AFError if an error occured
     */
    func signup(email: String, phoneNumber: String, firstName: String, lastName: String, languageCode: String) -> Future<ResponseObject<MappableDataObject<Customer>>?, Errors> {
        let promise = Promise<ResponseObject<MappableDataObject<Customer>>?, Errors>()

        let params: Parameters = [
            "email": email,
            "phone_number": phoneNumber,
            "first_name": firstName,
            "last_name": lastName,
            "language_code": languageCode
        ]

        NetworkRequest.request(url: "/v1/customers/signup", queryParameters: nil, bodyParameters: params, withBearer: false).responseJSONErrorCheck { response in

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
     Signup endpoint for Customer
     - parameter email: Customer's email
     - parameter phoneNumber: Customer's phoneNumber
     - parameter password: Customer's password
     - parameter verificationCode: Customer's SMS verification code

     - Returns: A Future ResponseObject containing a Customer Object, or an AFError if an error occured
     */
    func confirmSignup(email: String, phoneNumber: String, password: String, verificationCode: String) -> Future<ResponseObject<MappableDataObject<Customer>>?, Errors> {
        let promise = Promise<ResponseObject<MappableDataObject<Customer>>?, Errors>()

        let params: Parameters = [
            "email": email,
            "password": password,
            "verification_code": verificationCode
        ]

        NetworkRequest.request(url: "/v1/customers/signup/confirm", queryParameters: nil, bodyParameters: params, withBearer: false).responseJSONErrorCheck { response in

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
     Endpoint to request Customer's phone number verification code
     - parameter customerId: Customer's ID

     - Returns: A Future ResponseObject containing a Customer Object, or an AFError if an error occured
     */
    func requestPhoneVerificationCode(customerId: Int) -> Future<ResponseObject<EmptyMappableObject>?, Errors> {
        let promise = Promise<ResponseObject<EmptyMappableObject>?, Errors>()

        NetworkRequest.request(url: "/v1/customers/\(customerId)/phone-number/request-verification", method: .put, queryParameters: nil, withBearer: true).responseJSON { response in

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
     Endpoint to verify Customer's phone number
     - parameter customerId: Customer's ID
     - parameter verificationCode: Verification Code sent by SMS

     - Returns: A Future ResponseObject containing a Customer Object, or an AFError if an error occured
     */
    func verifyPhoneNumber(customerId: Int, verificationCode: String) -> Future<ResponseObject<EmptyMappableObject>?, Errors> {
        let promise = Promise<ResponseObject<EmptyMappableObject>?, Errors>()

        let params: Parameters = [
            "verification_code": verificationCode
        ]

        NetworkRequest.request(url: "/v1/customers/\(customerId)/phone-number/verify", method: .put, queryParameters: nil, bodyParameters: params, withBearer: true).responseJSONErrorCheck { response in

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
