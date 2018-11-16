//
//  NetworkRequest+Admin.swift
//  voluxe-customerUITests
//
//  Created by Christoph on 5/21/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Alamofire
import Foundation

extension NetworkRequest {

    // MARK:- Base request creation

    static func request(url: String,
                        method: HTTPMethod,
                        queryParameters: Parameters? = nil,
                        bodyParameters: Parameters? = nil,
                        bodyEncoding: ParameterEncoding = URLEncoding.httpBody,
                        headers: HTTPHeaders = [:],
                        includeBearer: Bool = true,
                        includeClient: Bool = true) -> DataRequest
    {
        let finalUrl = "\(Config.sharedInstance.apiEndpoint())\(url)"

        var originalRequest: URLRequest?
        var finalRequest: DataRequest?

        var mutHeader = headers
        if includeBearer { self.addBearer(header: &mutHeader) }
        if includeClient { mutHeader["X-CLIENT-ID"] = Config.sharedInstance.apiClientId() }

        // IMPORTANT!
        // This is set artificially high to avoid future version
        // check failures, this is required because there does
        // not seem to be a way to set or share the info.plist
        // from the main app for the runner app that is created
        // by UI tests.  If for some reason we release a client
        // app that uses AdminAPI, we might have to reconsider
        // this change.
        mutHeader["x-application-version"] = "luxe_by_volvo_customer_ios:100.0.0"

        // TODO clean up
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

        // TODO too many ! to be safe
        return finalRequest!
    }

    // MARK:- Specific request creation

    static func get(url: String,
                    queryParameters: Parameters? = nil,
                    includeBearer: Bool = true) -> DataRequest
    {
        return NetworkRequest.request(url: url,
                                      method: .get,
                                      queryParameters: queryParameters,
                                      includeBearer: includeBearer,
                                      includeClient: false)
    }

    static func post(url: String,
                     bodyParameters: Parameters? = nil) -> DataRequest
    {
        return NetworkRequest.request(url: url,
                                      method: .post,
                                      bodyParameters: bodyParameters,
                                      includeBearer: true,
                                      includeClient: false)
    }
}
