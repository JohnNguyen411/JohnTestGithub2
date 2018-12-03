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
            
            if UserDefaults.standard.enableAlamoFireLogging {
                // print data
                let jsonString = String(data: data, encoding: .utf8)
                print("data: \(jsonString ?? "")")
            }
            
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
            luxeAPIError = LuxeAPIError(statusCode: self.statusCode)
        } else {
            luxeAPIError = LuxeAPIError(code: luxeAPIError?.code, message: luxeAPIError?.message, statusCode: self.statusCode)
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
