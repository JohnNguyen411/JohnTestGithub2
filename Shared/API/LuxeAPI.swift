//
//  DriverAPI.swift
//  voluxe-driver
//
//  Created by Christoph on 10/17/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation

// TODO https://app.asana.com/0/858610969087925/908722711775269/f
// TODO documentation
extension RestAPIHost {
    var string: String {
        switch self {
            case .development: return "https://development-uswest2.api.luxe.com"
            case .staging: return "https://staging-uswest2.api.luxe.com"
            case .production: return "https://uswest2.api.luxe.com"
        }
    }
}

// TODO https://app.asana.com/0/858610969087925/908722711775269/f
// TODO documentation
class LuxeAPI: RestAPI {

    var host = RestAPIHost.development {
        didSet {
            self.updateHeaders()
        }
    }

    var token: String? {
        didSet {
            self.updateHeaders()
        }
    }

    var headers: RestAPIHeaders = [:]

    func updateHeaders() {
        let token = self.token
        self.headers["Authorization"] = token != nil ? "Bearer \(token!)" : nil
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
    
    func initToken(token: String) {
        self.token = token
    }
}

// TODO https://app.asana.com/0/858610969087925/908722711775269/f
// TODO documentation
struct LuxeAPIError: Codable, Error {

    // https://development-docs.ingress.luxe.com/v1/docs/#/
    enum Code: String, Codable {
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
  
    func decode<T: Decodable>(convertFromSnakeCase: Bool = false, reportErrors: Bool = true) -> T? {
        guard let data = self.data else { return nil }
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.luxeISO8601)
            if convertFromSnakeCase {
                decoder.keyDecodingStrategy = .convertFromSnakeCase
            }
            // print data
            let jsonString = String(data: data, encoding: .utf8)
            print("data: \(jsonString ?? "")")
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
        
        var luxeAPIError: LuxeAPIError? = self.decode(reportErrors: false)
        
        // if no error, return nil
        if (luxeAPIError == nil || luxeAPIError?.code == nil) && !hasErrored() {
            return nil
        }
        
        if (luxeAPIError == nil || luxeAPIError?.code == nil) && hasErrored() {
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
