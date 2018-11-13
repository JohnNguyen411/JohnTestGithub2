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

    // https://development-docs.ingress.luxe.com/v1/docs/#/
    enum Code: String, Codable {
        case E2001
        case E2002
        case E2003
        case E2004
        case E2005
        case E3001
        case E3006
        case E4012
        case E4021
    }

    let error: Bool
    let code: Code
    let message: String
}

// MARK:- Codable extension

extension RestAPIResponse {
  
    func decode<T: Decodable>(reportErrors: Bool = true) -> T? {
        guard let data = self.data else { return nil }
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.luxeISO8601)
            let object = try decoder.decode(T.self, from: data)
            return object
        } catch {
            // TODO log to console?
            if reportErrors { NSLog("\n\nDECODE ERROR: \(error)\n\n") }
            return nil
        }
    }
}

// MARK:- Custom decodings

extension RestAPIResponse {

    func asError() -> LuxeAPIError? {
        let response: LuxeAPIError? = self.decode(reportErrors: false)
        return response
    }

    func asErrorCode() -> LuxeAPIError.Code? {
        return self.asError()?.code
    }

    func asString() -> String? {
        guard let data = self.data else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
