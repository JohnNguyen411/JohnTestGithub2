//
//  DriverAPI.swift
//  voluxe-driver
//
//  Created by Christoph on 10/17/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation

// TODO this is overkill
enum DriverAPIRoutes: RestAPIRoute {
    case dealerships = "v1/drivers/driverID/dealerships"
    case login = "v1/users/login"
    case logout = "v1/users/logout"
    case me = "v1/users/me"
}

extension RestAPIHost {
    var string: String {
        switch self {
            case .development: return "https://development-uswest2.api.luxe.com"
            case .staging: return "https://staging-uswest2.api.luxe.com"
            case .production: return "https://uswest2.api.luxe.com"
        }
    }
}

// TODO this needs to become LuxeAPI and manage token/headers
class LuxeAPI: RestAPI {

    // TODO is there a way to keep this private but accessible to extensions?
//    static let api = DriverAPI()
//    init() {
//        self.updateHeaders()
//    }

    // TODO default values
    // TODO should be configurable at run time
    var host = RestAPIHost.development
    var headers: RestAPIHeaders = [:]
    var defaultHeaders: RestAPIHeaders = [:]

    func updateHeaders(with token: String? = nil) {
        var headers = self.defaultHeaders
        // TODO find a cleaner way to do this
        headers["Authorization"] = token != nil ? "Bearer \(token!)" : nil
        self.headers = headers
    }
}

// TODO LuxeAPIError or VolvoAPIError
struct DriverAPIError: Codable {

    // TODO string enum for code?
    typealias Code = String

    let error: Bool
    let code: Code
    let message: String
}

// TODO LuxeAPIError or VolvoAPIError
extension RestAPIResponse {

    func asError() -> DriverAPIError? {
        guard let data = self.data else { return nil }
        return try? JSONDecoder().decode(DriverAPIError.self, from: data)
    }

    func asErrorCode() -> DriverAPIError.Code? {
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
