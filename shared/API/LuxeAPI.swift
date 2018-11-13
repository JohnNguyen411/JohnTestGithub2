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

// TODO move to new file
struct LuxeAPIError: Codable {

    // TODO string enum for code?
    // https://development-docs.ingress.luxe.com/v1/docs/#/
    typealias Code = String

    let code: Code?
    let message: String?
    let statusCode: Int?
    
    init(statusCode: Int?) {
        self.statusCode = statusCode
        self.code = nil
        self.message = nil
    }
    
    init(code: Code?, message: String?, statusCode: Int?) {
        self.statusCode = statusCode
        self.code = code
        self.message = message
    }
}

// MARK:- Codable extension

extension RestAPIResponse {
  
    func decode<T: Decodable>(reportErrors: Bool = true) -> T? {
        guard let data = self.data else { return nil }
        do {
            let object = try JSONDecoder().decode(T.self, from: data)
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
        
        var luxeAPIError: LuxeAPIError? = self.decode(reportErrors: false)
        if luxeAPIError == nil && hasErrored() {
            luxeAPIError = LuxeAPIError(statusCode: self.statusCode())
        } else {
            luxeAPIError = LuxeAPIError(code: luxeAPIError?.code, message: luxeAPIError?.message, statusCode: self.statusCode())
        }
        
        return luxeAPIError
    }

    // Can return nil even if errored (502, etc)
    func asErrorCode() -> LuxeAPIError.Code? {
        return self.asError()?.code
    }
    
    func hasErrored() -> Bool {
        return self.error != nil
    }
    

    func asString() -> String? {
        guard let data = self.data else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
