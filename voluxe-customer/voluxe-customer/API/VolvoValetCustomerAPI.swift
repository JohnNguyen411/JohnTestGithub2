//
//  VolvoValetCustomerAPI.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 3/25/19.
//  Copyright © 2019 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import Alamofire
import LuxePnDSDK

class VolvoValetCustomerAPI: CustomerAPI {
    
    public static func initApi(host: RestAPIHost, applicationVersion: String) {
        api = VolvoValetCustomerAPI(host: host, applicationVersion: applicationVersion)
    }
    
    public override func get(route: RestAPIRoute,
                    queryParameters: RestAPIParameters? = nil,
                    completion: RestAPICompletion? = nil)
    {
        self.send(method: .get,
                  route: route,
                  headers: self.headers,
                  queryParameters: queryParameters,
                  completion: completion)
    }
    
    public override func patch(route: RestAPIRoute,
                      bodyParameters: RestAPIParameters?,
                      completion: RestAPICompletion?)
    {
        self.send(method: .patch,
                  route: route,
                  headers: self.headers,
                  bodyParameters: bodyParameters,
                  completion: completion)
    }
    
    public override func delete(route: RestAPIRoute,
                       bodyParameters: RestAPIParameters? = nil,
                       completion: RestAPICompletion?)
    {
        self.send(method: .delete,
                  route: route,
                  headers: self.headers,
                  bodyParameters: bodyParameters,
                  completion: completion)
    }
    
    public override func put(route: RestAPIRoute,
                    bodyParameters: RestAPIParameters? = nil,
                    bodyJSON: Data? = nil,
                    completion: RestAPICompletion? = nil)
    {
        self.send(method: .put,
                  route: route,
                  headers: self.headers,
                  queryParameters: nil,
                  bodyParameters: bodyParameters,
                  bodyData: bodyJSON,
                  completion: completion)
    }
    
    public override func post(route: RestAPIRoute,
                     queryParameters: RestAPIParameters? = nil,
                     bodyParameters: RestAPIParameters? = nil,
                     completion: RestAPICompletion? = nil)
    {
        self.send(method: .post,
                  route: route,
                  headers: self.headers,
                  queryParameters: queryParameters,
                  bodyParameters: bodyParameters,
                  completion: completion)
    }
    
}
