//
//  NetworkRequest.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 12/7/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import BrightFutures

/***
 *
 * All the URLs need to be partial Urls, ie: /v1/dealerships
 *
 ***/
class NetworkRequest {
    
    static func request(url: String, method: HTTPMethod, parameters: Parameters?, headers: HTTPHeaders?) -> DataRequest {
        let finalUrl = "\(Config.sharedInstance.apiEndpoint())\(url)"
        return Alamofire.request(finalUrl, method: method, parameters: parameters, headers: headers)
    }
    
    static func request(url: String, method: HTTPMethod, parameters: Parameters?, headers: HTTPHeaders, addBearer: Bool) -> DataRequest {
        var mutHeader = headers
        if addBearer {
            NetworkRequest.addBearer(header: &mutHeader)
        }
        return NetworkRequest.request(url: url, method: method, parameters: parameters, headers: mutHeader)
    }
    
    static func request(url: String, method: HTTPMethod, parameters: Parameters?, withBearer: Bool) -> DataRequest {
        let headers: [String: String] = [:]
        return NetworkRequest.request(url: url, method: method, parameters: parameters, headers: headers, addBearer: withBearer)
    }
    
    static func request(url: String, parameters: Parameters?, withBearer: Bool) -> DataRequest {
        return NetworkRequest.request(url: url, method: .get, parameters: parameters, withBearer: withBearer)
    }
    
    static func request(url: String, parameters: Parameters?) -> DataRequest {
        return NetworkRequest.request(url: url, method: .get, parameters: parameters, headers: nil)
    }
    
    static func addBearer(header: inout [String: String]) {
        header["Authorization"] = "Bearer \(UserManager.sharedInstance.getAccessToken() ?? "")"
    }
}
