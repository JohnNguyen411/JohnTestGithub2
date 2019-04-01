//
//  DriverAPI.swift
//  voluxe-driver
//
//  Created by Christoph on 10/17/18.
//  Copyright © 2018 Volvo Valet. All rights reserved.
//

import Foundation

// Luxe API specific hosts for each environment
extension RestAPIHost {
    public var string: String {
        switch self {
            case .development: return "https://development-uswest2.api.luxe.com"
            case .staging: return "https://staging-uswest2.api.luxe.com"
            case .production: return "https://uswest2.api.luxe.com"
        }
    }
}

// Luxe API specific implementation to manage the API token
open class LuxeAPI: RestAPI {
    
    public func inspect(urlResponse: HTTPURLResponse?, apiResponse: RestAPIResponse?) {
        
    }
    
    public var host = RestAPIHost.development {
        didSet {
            self.updateHeaders()
        }
    }

    public var token: String? {
        didSet {
            self.updateHeaders()
        }
    }

    public var headers: RestAPIHeaders = [:]

    func updateHeaders() {
        let token = self.token
        self.headers["Authorization"] = token != nil ? "Bearer \(token!)" : nil
    }
    
    public static func encodeParamsArray(array: [Any], key: String) -> String {
        let keyParam = "\(key)"
        var params = ""
        for (index, object) in array.enumerated() {
            params += "\(keyParam)[\(index)]=\(object)&"
        }
        params.removeLast()
        return params
    }
    
    public func initToken(token: String) {
        self.token = token
    }

    public func clearToken() {
        self.token = nil
        self.updateHeaders()
    }
    
    // To be overriden by Clients
    open func get(route: RestAPIRoute,
                    queryParameters: RestAPIParameters? = nil,
                    completion: RestAPICompletion? = nil)
    {
        assertionFailure("get from LuxeAPI not implemented by Client app")
    }
    
    open func patch(route: RestAPIRoute,
                      bodyParameters: RestAPIParameters?,
                      completion: RestAPICompletion?)
    {
        assertionFailure("patch from LuxeAPI not implemented by Client app")
    }
    
    open func delete(route: RestAPIRoute,
                       bodyParameters: RestAPIParameters? = nil,
                       completion: RestAPICompletion?)
    {
        assertionFailure("delete from LuxeAPI not implemented by Client app")
    }
    
    open func put(route: RestAPIRoute,
                    bodyParameters: RestAPIParameters? = nil,
                    bodyJSON: Data? = nil,
                    completion: RestAPICompletion? = nil)
    {
        assertionFailure("put from LuxeAPI not implemented by Client app")
    }
    
    open func post(route: RestAPIRoute,
                     queryParameters: RestAPIParameters? = nil,
                     bodyParameters: RestAPIParameters? = nil,
                     completion: RestAPICompletion? = nil)
    {
        assertionFailure("post from LuxeAPI not implemented by Client app")
    }
}



// MARK:- Codable extension

extension RestAPIResponse {
  
    func decode<T: Decodable>(convertFromSnakeCase: Bool = false, reportErrors: Bool = true) -> T? {
        guard let data = self.data else { return nil }
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.localISO8601)
            if convertFromSnakeCase {
                decoder.keyDecodingStrategy = .convertFromSnakeCase
            }
            
            let object = try decoder.decode(T.self, from: data)
            return object
        } catch {
            #if DEBUG
                if reportErrors { NSLog("\n\nDECODE ERROR: \(error)\n\n") }
            #endif
            return nil
        }
    }
}

// MARK:- Custom decodings
extension RestAPIResponse {

    public func asError() -> LuxeAPIError? {
        
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
    public func asErrorCode() -> LuxeAPIError.Code? {
        return self.asError()?.code
    }
    
    public func hasErrored() -> Bool {
        return self.error != nil
    }
    

    public func asString() -> String? {
        guard let data = self.data else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
