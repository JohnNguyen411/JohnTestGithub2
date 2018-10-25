//
//  DriverAPI.swift
//  voluxe-driver
//
//  Created by Christoph on 10/17/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation

extension RestAPIHost {
    var string: String {
        switch self {
            case .development: return "https://development-uswest2.api.luxe.com"
            case .staging: return "https://staging-uswest2.api.luxe.com"
            case .production: return "https://uswest2.api.luxe.com"
        }
    }
}

class LuxeAPI: RestAPI {

    // TODO default values
    // TODO should be configurable at run time
    var host = RestAPIHost.development
    var headers: RestAPIHeaders = [:]
    var defaultHeaders: RestAPIHeaders = [:]

    // TODO find a cleaner way to do this
    // TODO documentation
    func updateHeaders(with token: String? = nil) {
        var headers = self.defaultHeaders
        headers["Authorization"] = token != nil ? "Bearer \(token!)" : nil
        self.headers = headers
    }
}

struct LuxeAPIError: Codable {

    // TODO string enum for code?
    // https://development-docs.ingress.luxe.com/v1/docs/#/
    typealias Code = String

    let error: Bool
    let code: Code
    let message: String
}

// TODO LuxeAPIError or VolvoAPIError
extension RestAPIResponse {

    func asError() -> LuxeAPIError? {
        guard let data = self.data else { return nil }
        return try? JSONDecoder().decode(LuxeAPIError.self, from: data)
    }

    func asErrorCode() -> LuxeAPIError.Code? {
        return self.asError()?.code
    }

    func decode<T: Decodable>() -> T? {
        guard let data = self.data else { return nil }
        do {
            let object = try JSONDecoder().decode(T.self, from: data)
            return object
        } catch {
            NSLog("\n\nDECODE ERROR: \(error)\n\n")
            return nil
        }
    }

    func asString() -> String? {
        guard let data = self.data else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
