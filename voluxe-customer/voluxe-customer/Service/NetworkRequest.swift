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
    
    static let ID_PLACEHOLDER: String = "__ID__"
    
    static func request(url: String, method: HTTPMethod, queryParameters: Parameters?, bodyParameters: Parameters? = nil, bodyEncoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders?) -> DataRequest {
        let finalUrl = "\(Config.sharedInstance.apiEndpoint())\(url)"
        
        var originalRequest: URLRequest?
        var finalRequest: DataRequest?

        do {
            originalRequest = try URLRequest(url: finalUrl, method: method, headers: headers)
            let queryEncodedURLRequest = try URLEncoding.default.encode(originalRequest!, with: queryParameters)
            let queryAndBodyEncodedURLRequest = try bodyEncoding.encode(queryEncodedURLRequest, with: bodyParameters)
            finalRequest = Alamofire.request(queryAndBodyEncodedURLRequest)
        } catch {
            finalRequest = Alamofire.request(originalRequest!)
        }
        
        //let request = Alamofire.request(finalUrl, method: method, parameters: parameters, headers: headers)
        Logger.print("NetworkRequest \(originalRequest!)")
        if let queryParameters = queryParameters {
            Logger.print("parameters \(queryParameters)")
        }
        if let headers = headers {
            Logger.print("headers \(headers)")
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
    
    static func request(url: String, method: HTTPMethod, queryParameters: Parameters?, withBearer: Bool) -> DataRequest {
        let headers: [String: String] = [:]
        return NetworkRequest.request(url: url, method: method, queryParameters: queryParameters, headers: headers, addBearer: withBearer)
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
    
    static func replaceValues(url: String, values: [String]) -> String{
        var modifiedUrl = url
        for id in values {
            modifiedUrl = String.stringByReplacingFirstOccurrenceOfString(string: modifiedUrl, target: ID_PLACEHOLDER, withString: id)
        }
        return modifiedUrl
    }
}
