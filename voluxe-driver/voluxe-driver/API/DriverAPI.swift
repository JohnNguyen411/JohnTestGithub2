//
//  DriverAPI.swift
//  voluxe-driver
//
//  Created by Christoph on 11/14/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation

extension RestAPIHost {
    var clientId: String {
        switch self {
            case .development: return "2SRLMO648SEEK7X66AMTLYZGSE8RSL12"
            case .staging: return "A8Y93ZCB8859EFIXUCEYVG2UBVB3NMUI"
            case .production: return "TK4KKKO9X30YKOA3VPYWBTV55W1BIY2L"
        }
    }
}

open class DriverAPI: LuxeAPI {

    static let api = DriverAPI()

    override init() {
        super.init()
        self.host = UserDefaults.standard.apiHost
    }

    override open func updateHeaders() {
        super.updateHeaders()
        self.headers["X-CLIENT-ID"] = self.host.clientId
        self.headers["x-application-version"] = "luxe_by_volvo_driver_ios:\(Bundle.current.version)"
    }
    
    open override func get(route: RestAPIRoute,
                             queryParameters: RestAPIParameters? = nil,
                             completion: RestAPICompletion? = nil)
    {
        self.send(method: .get,
                  route: route,
                  headers: self.headers,
                  queryParameters: queryParameters,
                  completion: completion)
    }
    
    open override func patch(route: RestAPIRoute,
                               bodyParameters: RestAPIParameters?,
                               completion: RestAPICompletion?)
    {
        self.send(method: .patch,
                  route: route,
                  headers: self.headers,
                  bodyParameters: bodyParameters,
                  completion: completion)
    }
    
    open override func delete(route: RestAPIRoute,
                                bodyParameters: RestAPIParameters? = nil,
                                completion: RestAPICompletion?)
    {
        self.send(method: .delete,
                  route: route,
                  headers: self.headers,
                  bodyParameters: bodyParameters,
                  completion: completion)
    }
    
    open override func put(route: RestAPIRoute,
                             bodyParameters: RestAPIParameters? = nil,
                             bodyJSON: Data? = nil,
                             completion: RestAPICompletion? = nil)
    {
        self.send(method: .put,
                  route: route,
                  headers: self.headers,
                  queryParameters: nil,
                  bodyParameters: bodyParameters,
                  bodyData: bodyJSON,
                  completion: completion)
    }
    
    open override func post(route: RestAPIRoute,
                              queryParameters: RestAPIParameters? = nil,
                              bodyParameters: RestAPIParameters? = nil,
                              completion: RestAPICompletion? = nil)
    {
        self.send(method: .post,
                  route: route,
                  headers: self.headers,
                  queryParameters: queryParameters,
                  bodyParameters: bodyParameters,
                  completion: completion)
    }
}
