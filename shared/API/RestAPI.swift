//
//  RestAPI.swift
//  voluxe-driver
//
//  Created by Christoph on 10/17/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation

// TODO documentation
enum RestAPIHost: String {
    case development
    case staging
    case production
}

typealias RestAPIRoute = String

typealias RestAPIParameters = [String: Any]

typealias RestAPIToken = String

typealias RestAPIHeaders = [String: String]

struct RestAPIResponse {
    let data: Data?
    let error: Error?
}

typealias RestAPICompletion = ((RestAPIResponse?) -> ())

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

    // TODO need to expose upload here
}

extension RestAPI {

    func urlFromHost(for route: RestAPIRoute) -> String {
        return "\(self.host.string)/\(route)"
    }
}