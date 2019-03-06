//
//  AdminAPI.swift
//  voluxe-customerUITests
//
//  Created by Johan Giroux on 11/26/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation


// TODO replace voluxe-customer AdminAPI with this one
class AdminAPI: LuxeAPI {
    
    static let api = AdminAPI()
    private override init() {
        super.init()
        self.updateHeaders()
    }
    
    override func updateHeaders() {
        super.updateHeaders()
        self.headers["x-application-version"] = "luxe_by_volvo_customer_ios:100.0.0"
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
            self.api.token = response?.asToken()
            completion(response?.asErrorCode())
        }
    }
    
    static func user(for email: String, completion: @escaping ((RestAPIResponse.User?, LuxeAPIError.Code?) -> Void)) {
        
        let parameters: RestAPIParameters = ["email": email]
        
        self.api.get(route: "v1/users", queryParameters: parameters) {
            response in
            let user = response?.asUser()
            completion(user, response?.asErrorCode())
        }
    }
    
    static func verificationCode(for userId: Int, completion: @escaping ((RestAPIResponse.VerificationCode?, LuxeAPIError.Code?) -> Void)) {
        
        let parameters: RestAPIParameters = ["user_id": "\(userId)"]
        
        self.api.get(route: "v1/phone-verification-codes", queryParameters: parameters) {
            response in
            let code = response?.asVerificationCode()
            completion(code, response?.asErrorCode())
        }
    }
    
    
    
    static func login(email: String,
                      password: String,
                      requestVerificationCodeFor customerEmail: String,
                      completion: @escaping ((RestAPIResponse.VerificationCode?, LuxeAPIError.Code?) -> Void))
    {
        // log into admin API
        AdminAPI.login(email: email, password: password) { error in
            if let loginError = error {
                completion(nil, loginError)
                return
            }
            
            // get customer ID for customer email
            AdminAPI.user(for: customerEmail) { user, error in
                if let userError = error {
                    completion(nil, userError)
                    return
                }
                
                guard let user = user else {
                    completion(nil, .E4001)
                    return
                }

                
                // get verification code for customer ID
                AdminAPI.verificationCode(for: user.id) { code, error in
                    if let code = code {
                        completion(code, nil)
                    } else {
                        completion(nil, error)
                    }
                }
            }
        }
    }
}

extension RestAPIResponse {
    
    // TODO need coding keys?
    // TODO does this need to be exposed outside the API?
    struct User: Codable {
        let id: Int
        let email: String
        let first_name: String
        let last_name: String
        let language_code: String
        let password_reset_required: Bool
        let last_login_at: Date?
        let photo_url: String?
        let enabled: Bool
        let phone_number: String?
        let phone_number_verified: Bool?
        let type: String?
    }
    
    struct UserAndToken: Codable {
        let user: User
        let token: String
    }
    
    struct UsersResponse: Codable {
        let data: [User]
    }
    
    func asUser() -> User? {
        let response: UsersResponse? = self.decode()
        return response?.data.first
    }
    
    // TODO need to find a better name
    struct TokenResponse: Codable {
        let data: UserAndToken
    }
    
    func asToken() -> String? {
        let userAndToken: TokenResponse? = self.decode()
        return userAndToken?.data.token
    }
    
    struct VerificationCode: Codable {
        let id: Int
        let value: String?
        let phone_number: String?
        let user_id: Int
        let used_at: String?
        let expires_at: String?
        let created_at: String?
        let updated_at: String?
    }
    
    struct CodeResponse: Codable {
        let data: [VerificationCode]
    }
    
    func asVerificationCode() -> VerificationCode? {
        let response: CodeResponse? = self.decode()
        return response?.data.first
    }
    
    func asVerificationCodeString() -> String? {
        let response: CodeResponse? = self.decode()
        return response?.data.first?.value
    }
}

