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
    
    // Single entry point for all our API requests
    static func request(url: String, method: HTTPMethod, queryParameters: Parameters?, bodyParameters: Parameters? = nil, bodyEncoding: ParameterEncoding = URLEncoding.httpBody, headers: HTTPHeaders) -> DataRequest {
        let finalUrl = "\(Config.sharedInstance.apiEndpoint())\(url)"
        
        var originalRequest: URLRequest?
        var finalRequest: DataRequest?
        
        var mutHeader = headers
        mutHeader["X-CLIENT-ID"] = Config.sharedInstance.apiClientId()
        mutHeader["x-application-version"] = "luxe_by_volvo_customer_ios:\(UIApplication.appBuild())"

        do {
            originalRequest = try URLRequest(url: finalUrl, method: method, headers: mutHeader)
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

    //MARK: Helper methods
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
        return NetworkRequest.request(url: url, method: .get, queryParameters: queryParameters, headers: [:])
    }
    
    static func addBearer(header: inout [String: String]) {
        if let accessToken = UserManager.sharedInstance.getAccessToken() {
            header["Authorization"] = "Bearer \(accessToken)"
        }
    }
    
    static func encodeParamsArray(array: [Any], key: String) -> String {
        var params = "key="
        for object in array {
            params += "\(object),"
        }
        params.removeLast()
        return params
    }
    
    static func checkErrors(response: DataResponse<Any>) {
        // check for custom errors
        if let json = response.result.value as? [String: Any] {
            let responseObject = ResponseObject<EmptyMappableObject>(json: json)
            if let error = responseObject.error, let code = error.getCode() {
                weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
                
                switch code {
                // invalid token
                case .E2001, .E2002, .E2003, .E2004:
                    // logout
                    UserManager.sharedInstance.logout()
                    appDelegate?.startApp()
                // User Disabled
                case .E3001:
                    // logout
                    UserManager.sharedInstance.logout()
                    appDelegate?.startApp()
                // Need Force Upgrade
                case .E3006:
                    appDelegate?.showForceUpgradeDialog()
                default:
                    break
                    
                }
            }
        }
    }
    
}

extension DataRequest {
    
    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter options:           The JSON serialization reading options. Defaults to `.allowFragments`.
    /// - parameter completionHandler: A closure to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    public func responseJSONErrorCheck(
        queue: DispatchQueue? = nil,
        options: JSONSerialization.ReadingOptions = .allowFragments,
        completionHandler: @escaping (DataResponse<Any>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: DataRequest.jsonResponseSerializer(options: options),
            completionHandler: { response in
                NetworkRequest.checkErrors(response: response)
                completionHandler(response)
            }
        )
    }
}

