//
//  CustomerAPI+Customer.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 11/6/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

extension CustomerAPI {
    
    public static func login(email: String,
                      password: String,
                      completion: @escaping ((Token?, LuxeAPIError?) -> ()))
    {
        let parameters = ["email": email,
                          "password": password,
                          "as": "customer"]
        
        self.api.post(route: "v1/users/login", bodyParameters: parameters) {
            response in
            let token = response?.decodeToken() ?? nil
            self.api.token = token?.token
            completion(token, response?.asError())
        }
    }
    
    public static func login(phoneNumber: String,
                      password: String,
                      completion: @escaping ((Token?, LuxeAPIError?) -> ()))
    {
        let parameters = ["phone_number": phoneNumber,
                          "password": password,
                          "as": "customer"]
        
        self.api.post(route: "v1/users/login", bodyParameters: parameters) {
            response in
            let token = response?.decodeToken() ?? nil
            self.api.token = token?.token
            completion(token, response?.asError())
        }
    }
    
    public static func logout(completion: ((LuxeAPIError?) -> ())? = nil) {
        self.api.post(route: "v1/users/logout") {
            response in
            completion?(response?.asError())
        }
        self.api.updateHeaders()
    }
}

private extension RestAPIResponse {
    
    private struct EncodedToken: Codable {
        var data: Token
    }
    
    func decodeToken() -> Token? {
        let token: EncodedToken? = self.decode()
        return token?.data
    }
}
