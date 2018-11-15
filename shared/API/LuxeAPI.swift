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
    
    static func encodeParamsArray(array: [Any], key: String) -> String {
        let keyParam = "\(key)"
        var params = ""
        for (index, object) in array.enumerated() {
            params += "\(keyParam)[\(index)]=\(object)&"
        }
        params.removeLast()
        return params
    }
}

// TODO move to new file
struct LuxeAPIError: Codable, Error {

    // for all error code, see docs: https://development-docs.ingress.luxe.com/v1/docs/#/
    public enum Code: String, Codable {
        case E2001
        case E2002
        case E2003
        case E2004
        case E2005
        case E3001
        case E3002
        case E3003
        case E3004
        case E3005
        case E3006
        case E3011
        case E4001
        case E4002
        case E4003
        case E4004
        case E4005
        case E4006
        case E4007
        case E4008
        case E4009
        case E4010
        case E4011
        case E4012
        case E4013
        case E4014
        case E4015
        case E4016
        case E4017
        case E4018
        case E4019
        case E4020
        case E4021
        case E4022
        case E4023
        case E4046
        case E4049
        case E4050
        case E5001
        case E5002
    }
    
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
