//
//  CustomerAPI+Customer.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 11/6/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class CustomerAPI: LuxeAPI {
    
    // TODO can this be private?
    static let api = CustomerAPI()
    
    // TODO this is getting too complicated// TODO how to get correct client ID for host?
    // Prod: `TK4KKKO9X30YKOA3VPYWBTV55W1BIY2L`
    // Staging: `A8Y93ZCB8859EFIXUCEYVG2UBVB3NMUI`
    // Dev: `2SRLMO648SEEK7X66AMTLYZGSE8RSL12`
    // TODO need Bundle.main.version extension
    private override init() {
        super.init()
        self.defaultHeaders["X-CLIENT-ID"] = Config.sharedInstance.apiClientId()
        self.defaultHeaders["x-application-version"] = "luxe_by_volvo_customer_ios:\(Bundle.main.version)"
        self.updateHeaders()
    }
    
    static func login(email: String,
                      password: String,
                      completion: @escaping ((Token?, LuxeAPIError?) -> ()))
    {
        let parameters = ["email": email,
                          "password": password,
                          "as": "customer"]
        
        self.api.post(route: "v1/users/login", bodyParameters: parameters) {
            response in
            let token = response?.decodeToken() ?? nil
            self.api.updateHeaders(with: token?.token)
            completion(token, response?.asError())
        }
    }
    
    static func login(phoneNumber: String,
                      password: String,
                      completion: @escaping ((Token?, LuxeAPIError?) -> ()))
    {
        let parameters = ["phone_number": phoneNumber,
                          "password": password,
                          "as": "customer"]
        
        self.api.post(route: "v1/users/login", bodyParameters: parameters) {
            response in
            let token = response?.decodeToken() ?? nil
            self.api.updateHeaders(with: token?.token)
            completion(token, response?.asError())
        }
    }
    
    static func logout(completion: ((LuxeAPIError?) -> ())? = nil) {
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
