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
    
    static func request(url: String, method: HTTPMethod, queryParameters: Parameters?, bodyParameters: Parameters? = nil, bodyEncoding: ParameterEncoding = URLEncoding.httpBody, headers: HTTPHeaders?) -> DataRequest {
        let finalUrl = "\(Config.sharedInstance.apiEndpoint())\(url)"
        
        var originalRequest: URLRequest?
        var finalRequest: DataRequest?

        do {
            originalRequest = try URLRequest(url: finalUrl, method: method, headers: headers)
            var queryEncodedURLRequest = try URLEncoding.default.encode(originalRequest!, with: queryParameters)
            if let bodyParameters = bodyParameters, let postData = (try? JSONSerialization.data(withJSONObject: bodyParameters, options: [])) {
                queryEncodedURLRequest.httpBody = postData
                queryEncodedURLRequest.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            }
            finalRequest = Alamofire.request(queryEncodedURLRequest)
        } catch {
            finalRequest = Alamofire.request(originalRequest!)
        }
        return finalRequest!
    }
    
    static func request(url: String, method: HTTPMethod, queryParameters: Parameters?, headers: HTTPHeaders, addBearer: Bool) -> DataRequest {
        var mutHeader = headers
        if addBearer {
            NetworkRequest.addBearer(header: &mutHeader)
        }
        return NetworkRequest.request(url: url, method: method, queryParameters: queryParameters, headers: mutHeader)
    }
    
    static func request(url: String, method: HTTPMethod, queryParameters: Parameters?, bodyParameters: Parameters, bodyEncoding: ParameterEncoding = URLEncoding.httpBody, withBearer: Bool) -> DataRequest {
        var mutHeader: [String: String] = [:]
        if withBearer {
            NetworkRequest.addBearer(header: &mutHeader)
        }
        return NetworkRequest.request(url: url, method: method, queryParameters: queryParameters, bodyParameters: bodyParameters, headers: mutHeader)
    }
    
    static func request(url: String, method: HTTPMethod, queryParameters: Parameters?, withBearer: Bool) -> DataRequest {
        let headers: [String: String] = [:]
        return NetworkRequest.request(url: url, method: method, queryParameters: queryParameters, headers: headers, addBearer: withBearer)
    }
    
    static func request(url: String, queryParameters: Parameters?, bodyParameters: Parameters, withBearer: Bool) -> DataRequest {
        var mutHeader: [String: String] = [:]
        if withBearer {
            NetworkRequest.addBearer(header: &mutHeader)
        }
        return NetworkRequest.request(url: url, method: .post, queryParameters: queryParameters, bodyParameters: bodyParameters, headers: mutHeader)
    }
    
    static func request(url: String, queryParameters: Parameters?, withBearer: Bool) -> DataRequest {
        return NetworkRequest.request(url: url, method: .get, queryParameters: queryParameters, withBearer: withBearer)
    }
    
    static func request(url: String, queryParameters: Parameters?) -> DataRequest {
        return NetworkRequest.request(url: url, method: .get, queryParameters: queryParameters, headers: nil)
    }
    
    static func addBearer(header: inout [String: String]) {
        header["Authorization"] = "Bearer \(UserManager.sharedInstance.getAccessToken() ?? "")"
    }
    
    static func encodeParamsArray(array: [Any], key: String) -> String {
        var params = "key="
        for object in array {
            params += "\(object),"
        }
        params.removeLast()
        return params
    }
}
