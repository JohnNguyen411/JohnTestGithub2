//
//  RestAPI.swift
//  voluxe-driver
//
//  Created by Christoph on 10/17/18.
//  Copyright © 2018 Volvo Valet. All rights reserved.
//

import Foundation

// Various environments for the RestAPI.  Clients are encouraged
// to extend and provide implementations that produce String or
// URL for each case, specific to their needs.  Check out LuxeAPI.swift
// for an example.
public enum RestAPIHost: String, CaseIterable {
    case development
    case staging
    case production
}

// Convenience type for API routes.
public typealias RestAPIRoute = String

// Convenience type for API parameters in the form of key:value pairs.
public typealias RestAPIParameters = [String: Any]

// Convenience type for API token.
public typealias RestAPIToken = String

// Convenience type for API headers in the form of key:value pairs.
public typealias RestAPIHeaders = [String: String]

// Convenience type used to encode upload data.
public enum RestAPIMimeType: String {

    case invalid
    case jpeg = "image/jpeg"
    case json = "application/json"

    public var name: String {
        switch self {
            case .jpeg: return "photo"
            case .json: return "text"
            default: return "unknown"
        }
    }

    public var filename: String {
        switch self {
            case .jpeg: return "photo.jpg"
            case .json: return "text.json"
            default: return "unknown"
        }
    }
}

// Convenience type to wrap all responses in the RestAPI.  This is the
// base response from RestAPI call to any upper layers.  Check out
// LuxeAPI.swift to see how it is customized into a specific form
// for the LuxeAPI.
public struct RestAPIResponse {
    public let data: Data?
    public let error: Error?
    public let statusCode: Int?
    
    public init(data: Data?, error: Error?, statusCode: Int?) {
        self.data = data
        self.error = error
        self.statusCode = statusCode
    }
}

// Convenience type to form asynchronous completion closures for
// API calls.
public typealias RestAPICompletion = ((RestAPIResponse?) -> ())

// Abstract protocol that defines how a Rest API should present
// itself.  The intent is to provided a uniform interface between
// an application specific API and a 3rd party networking framework.
// Check out how LuxeAPI uses this with an Alamofire implementation.
public protocol RestAPI {

    var host: RestAPIHost { get set }
    var headers: RestAPIHeaders { get set }

    func get(route: RestAPIRoute,
             queryParameters: RestAPIParameters?,
             completion: RestAPICompletion?)

    func patch(route: RestAPIRoute,
               bodyParameters: RestAPIParameters?,
               completion: RestAPICompletion?)

    func put(route: RestAPIRoute,
             bodyParameters: RestAPIParameters?,
             bodyJSON: Data?,
             completion: RestAPICompletion?)

    func post(route: RestAPIRoute,
              queryParameters: RestAPIParameters?,
              bodyParameters: RestAPIParameters?,
              completion: RestAPICompletion?)
    
    func delete(route: RestAPIRoute,
                bodyParameters: RestAPIParameters?,
                completion: RestAPICompletion?)

    // Provides a hook for application code to inspect a raw response
    // before sending the response up to higher levels.  This is useful
    // for broadcast app wide notifications like "update required", or
    // to dump responses to debug output.
    func inspect(urlResponse: HTTPURLResponse?, apiResponse: RestAPIResponse?)
}

// Convenience to transform a route into a fully qualified URL string.
extension RestAPI {

    public func urlFromHost(for route: RestAPIRoute) -> String {
        return "\(self.host.string)/\(route)"
    }
}
