//
//  AdminAPI.swift
//  voluxe-driverAPITests
//
//  Created by Christoph on 10/23/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation

// TODO replace voluxe-customer AdminAPI with this one
class AdminAPI: LuxeAPI {

    // TODO how to allow subclass to set headers?
    // TODO maybe allow default headers?
    // TODO does this need an application version?
    static private let api = AdminAPI()
    private override init() {
        super.init()
        self.defaultHeaders["x-application-version"] = "luxe_by_volvo_customer_ios:100.0.0"
        self.updateHeaders()
    }

    static func login(email: String,
                      password: String,
                      completion: @escaping ((LuxeAPIError.Code?) -> Void))
    {
        let route = "v1/users/login"
        let parameters: RestAPIParameters = ["email": email,
                                             "password": password,
                                             "as": "system_admin"]
        self.api.post(route: route, bodyParameters: parameters) {
            response in
            self.api.updateHeaders(with: response?.asToken())
            completion(response?.asErrorCode())
        }
    }

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

extension RestAPIResponse {

    // TODO need coding keys?
    // TODO does this need to be exposed outside the API?
    private struct User: Codable {
        let id: Int
        let email: String
        let first_name: String
        let last_name: String
        let language_code: String
        let password_reset_required: Bool
        let last_login_at: Date?
        let photo_url: String?
        let enabled: Bool
        let phone_number: String
        let phone_number_verified: Bool
        let type: String
    }

    private struct UserAndToken: Codable {
        let user: User
        let token: String
    }

    // TODO need to find a better name
    private struct TokenResponse: Codable {
        let data: UserAndToken
    }

    func asToken() -> String? {
        let userAndToken: TokenResponse? = self.decode()
        return userAndToken?.data.token
    }

    private struct VerificationCode: Codable {
        let id: Int
        let value: String?
        let phone_number: String?
        let user_id: Int
        let used_at: String?
        let expires_at: String?
        let created_at: String?
        let updated_at: String?
    }

    private struct CodeResponse: Codable {
        let data: [VerificationCode]
    }

    func asVerificationCodeString() -> String? {
        let response: CodeResponse? = self.decode()
        return response?.data.first?.value
    }
}
