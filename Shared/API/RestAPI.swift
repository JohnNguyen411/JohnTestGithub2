//
//  RestAPI.swift
//  voluxe-driver
//
//  Created by Christoph on 10/17/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation

// TODO https://app.asana.com/0/858610969087925/908722711775269/f
// TODO documentation
enum RestAPIHost: String, CaseIterable {
    case development
    case staging
    case production
}

// TODO https://app.asana.com/0/858610969087925/908722711775269/f
// TODO documentation
typealias RestAPIRoute = String

// TODO https://app.asana.com/0/858610969087925/908722711775269/f
// TODO documentation
typealias RestAPIParameters = [String: Any]

// TODO https://app.asana.com/0/858610969087925/908722711775269/f
// TODO documentation
typealias RestAPIToken = String

// TODO https://app.asana.com/0/858610969087925/908722711775269/f
// TODO documentation
typealias RestAPIHeaders = [String: String]

// TODO https://app.asana.com/0/858610969087925/908722711775269/f
// TODO documentation
struct RestAPIResponse {
    let data: Data?
    let error: Error?
    let statusCode: Int?
}

// TODO https://app.asana.com/0/858610969087925/908722711775269/f
// TODO documentation
typealias RestAPICompletion = ((RestAPIResponse?) -> ())

// TODO https://app.asana.com/0/858610969087925/908722711775269/f
// TODO documentation
protocol RestAPI {

    var host: RestAPIHost { get set }
    var headers: RestAPIHeaders { get set }

    func get(route: RestAPIRoute,
             queryParameters: RestAPIParameters?,
             completion: RestAPICompletion?)

    func patch(route: RestAPIRoute,
               bodyParameters: RestAPIParameters?,
               completion: RestAPICompletion?)

    // TODO change bodyJSON to Encodable
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

    // TODO need to expose upload here

    // TODO NSURLResponse may be too restrictive, maybe merge into RestAPIResponse
    // TODO how to support consuming a response if necessary
    func inspect(urlResponse: HTTPURLResponse?, apiResponse: RestAPIResponse?)
}

// TODO https://app.asana.com/0/858610969087925/908722711775269/f
// TODO documentation
extension RestAPI {

    func urlFromHost(for route: RestAPIRoute) -> String {
        return "\(self.host.string)/\(route)"
    }
}
