//
//  CustomerAPI+Login.swift
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
     Logout
     Logout the currently logged user

     - Returns: A Future ResponseObject containing an empty Object, or an AFError if an error occured
     */
    func logout() -> Future<ResponseObject<EmptyMappableObject>?, Errors> {
        let promise = Promise<ResponseObject<EmptyMappableObject>?, Errors>()

        NetworkRequest.request(url: "/v1/users/logout", method: .post, queryParameters: [:], withBearer: true).responseJSON { response in
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
     Login endpoint for Customer
     - parameter email: Customer's email
     - parameter password: Customer's password

     - Returns: A Future ResponseObject containing a Token Object, or an AFError if an error occured
     */
    func login(email: String, password: String) -> Future<ResponseObject<MappableDataObject<Token>>?, Errors> {
        let promise = Promise<ResponseObject<MappableDataObject<Token>>?, Errors>()

        let params: Parameters = [
            "email": email,
            "password": password
        ]

        NetworkRequest.request(url: "/v1/users/login", queryParameters: nil, bodyParameters: params, withBearer: false).responseJSONErrorCheck { response in

            let responseObject = ResponseObject<MappableDataObject<Token>>(json: response.result.value, allowEmptyData: false)

            if response.error == nil && responseObject.error == nil {
                promise.success(responseObject)
            } else {
                promise.failure(Errors(dataResponse: response, apiError: responseObject.error))
            }
        }
        return promise.future
    }

    /**
     Login endpoint for Customer
     - parameter phoneNumber: Customer's phone number
     - parameter password: Customer's password

     - Returns: A Future ResponseObject containing a Token Object, or an AFError if an error occured
     */
    func login(phoneNumber: String, password: String) -> Future<ResponseObject<MappableDataObject<Token>>?, Errors> {
        let promise = Promise<ResponseObject<MappableDataObject<Token>>?, Errors>()

        let params: Parameters = [
            "phone_number": phoneNumber,
            "password": password
        ]

        NetworkRequest.request(url: "/v1/users/login", queryParameters: nil, bodyParameters: params, withBearer: false).responseJSONErrorCheck { response in

            let responseObject = ResponseObject<MappableDataObject<Token>>(json: response.result.value, allowEmptyData: false)

            if response.error == nil && responseObject.error == nil {
                promise.success(responseObject)
            } else {
                promise.failure(Errors(dataResponse: response, apiError: responseObject.error))
            }

        }
        return promise.future
    }
}
