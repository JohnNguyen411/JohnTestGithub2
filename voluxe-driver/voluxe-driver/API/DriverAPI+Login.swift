//
//  DriverAPI+Login.swift
//  voluxe-driver
//
//  Created by Christoph on 10/19/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation

extension DriverAPI {

    static func login(email: String,
                      password: String,
                      completion: @escaping ((Driver?, LuxeAPIError.Code?) -> ()))
    {
        let parameters = ["email": email,
                          "password": password,
                          "as": "driver"]

        self.api.post(route: "v1/users/login", bodyParameters: parameters) {
            response in
            let (driver, token) = response?.decodeDriverAndToken() ?? (nil, nil)
            self.api.token = token
            completion(driver, response?.asErrorCode())
        }
    }

    /// If no completion closure is provided, this will not attempt
    /// to decode any response from the API.
    static func logout(completion: ((LuxeAPIError.Code?) -> ())? = nil) {

        // if there is no token then logout() was probably already called
        guard self.api.token != nil else {
            Log.unexpected(.missingValue, "logout() called without a token")
            completion?(nil)
            return
        }

        // tell the API the token is finished
        self.api.post(route: "v1/users/logout") {
            response in
            guard let completion = completion else { return }
            completion(response?.asErrorCode())
        }

        // clear the token and headers
        self.api.clearToken()
    }
}

private extension RestAPIResponse {

    private struct DriverAndToken: Codable {
        let user: Driver
        let token: String
    }

    private struct EncodedDriverAndToken: Codable {
        var data: DriverAndToken
    }

    func decodeDriverAndToken() -> (Driver?, String?) {
        let driverAndToken: EncodedDriverAndToken? = self.decode()
        return (driverAndToken?.data.user, driverAndToken?.data.token)
    }
}
