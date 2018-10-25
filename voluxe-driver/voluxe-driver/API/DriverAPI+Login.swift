//
//  DriverAPI+Login.swift
//  voluxe-driver
//
//  Created by Christoph on 10/19/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation

class DriverAPI: LuxeAPI {

    // TODO can this be private?
    static let api = DriverAPI()

    // TODO this is getting too complicated// TODO how to get correct client ID for host?
    // Prod: `TK4KKKO9X30YKOA3VPYWBTV55W1BIY2L`
    // Staging: `A8Y93ZCB8859EFIXUCEYVG2UBVB3NMUI`
    // Dev: `2SRLMO648SEEK7X66AMTLYZGSE8RSL12`
    // TODO need Bundle.main.version extension
    private override init() {
        super.init()
        self.defaultHeaders["X-CLIENT-ID"] = "2SRLMO648SEEK7X66AMTLYZGSE8RSL12"
        self.defaultHeaders["x-application-version"] = "luxe_by_volvo_driver_ios:1.0.0"
        self.updateHeaders()
    }

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
            self.api.updateHeaders(with: token)
            completion(driver, response?.asErrorCode())
        }
    }

    static func logout(completion: ((LuxeAPIError.Code?) -> ())? = nil) {
        self.api.post(route: "v1/users/logout") {
            response in
            completion?(response?.asErrorCode())
        }
        self.api.updateHeaders()
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
