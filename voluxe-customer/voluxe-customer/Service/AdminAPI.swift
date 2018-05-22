//
//  AdminAPI.swift
//  voluxe-customerUITests
//
//  Created by Christoph on 5/17/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper
import BrightFutures
import Foundation

class AdminAPI {

    static func login(email: String, password: String) -> Future<ResponseObject<MappableDataObject<Token>>?, Errors> {

        let promise = Promise<ResponseObject<MappableDataObject<Token>>?, Errors>()
        let params: Parameters = ["email": email,
                                  "password": password,
                                  "as": "system_admin"]
        let request = NetworkRequest.post(url: "/v1/users/login",
                                          bodyParameters: params)

        request.responseJSONErrorCheck {
            response in
            let responseObject = ResponseObject<MappableDataObject<Token>>(json: response.result.value, allowEmptyData: false)
            if response.error == nil && responseObject.error == nil {
                promise.success(responseObject)
            } else {
                promise.failure(Errors(dataResponse: response, apiError: responseObject.error))
            }
        }

        return promise.future
    }

    static func user(for email: String) -> Future<ResponseObject<MappableDataArray<User>>?, Errors> {

        let promise = Promise<ResponseObject<MappableDataArray<User>>?, Errors>()
        let params: Parameters = ["email": "\(email)"]
        let request = NetworkRequest.get(url: "/v1/users",
                                         queryParameters: params)

        request.responseJSONErrorCheck {
            response in
            let responseObject = ResponseObject<MappableDataArray<User>>(json: response.result.value, allowEmptyData: false)
            if response.error == nil && responseObject.error == nil {
                promise.success(responseObject)
            } else {
                promise.failure(Errors(dataResponse: response, apiError: responseObject.error))
            }
        }

        return promise.future
    }

    static func verificationCode(for userId: Int) -> Future<ResponseObject<MappableDataArray<VerificationCode>>?, Errors> {

        let promise = Promise<ResponseObject<MappableDataArray<VerificationCode>>?, Errors>()
        let params: Parameters = [ "user_id": "\(userId)" ]
        let request = NetworkRequest.get(url: "/v1/phone-verification-codes",
                                         queryParameters: params)

        request.responseJSONErrorCheck {
            response in
            let responseObject = ResponseObject<MappableDataArray<VerificationCode>>(json: response.result.value, allowEmptyData: false)
            if response.error == nil && responseObject.error == nil {
                promise.success(responseObject)
            } else {
                promise.failure(Errors(dataResponse: response, apiError: responseObject.error))
            }
        }

        return promise.future
    }

    static func login(email: String,
                      password: String,
                      requestVerificationCodeFor customerEmail: String,
                      completion: @escaping ((VerificationCode?) -> ()))
    {
        // log into admin API
        let request = AdminAPI.login(email: email, password: password)
        request.onSuccess {
            result in
            let tokenObject = result?.data?.result
            NetworkRequest.accessToken = tokenObject?.token

            // get customer ID for customer email
            let request = AdminAPI.user(for: customerEmail)
            request.onSuccess {
                result in
                let users = result?.data?.result

                // get verification code for customer ID
                let request = AdminAPI.verificationCode(for: users?.first?.id ?? 0)
                request.onSuccess {
                    result in
                    let codes = result?.data?.result
                    completion(codes?.first)
                }

                // failure means nil verification code
                request.onFailure {
                    error in
                    completion(nil)
                }
            }

            // failure means nil verification code
            request.onFailure {
                error in
                completion(nil)
            }
        }

        // failure means nil verification code
        request.onFailure {
            error in
            completion(nil)
        }
    }
}
