//
//  Config.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 12/6/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

class Config: NSObject {
    
    private static let devUrl = "https://development-uswest2.api.luxe.com"
    private static let stagingUrl = "https://development-uswest2.api.luxe.com"
    private static let prodUrl = "https://development-uswest2.api.luxe.com"
    
    private static let clientIdDev = "P2HHU4CKLS3JDQCF9ILSCAVPOJRN0LFS"
    private static let clientIdStaging = "P2HHU4CKLS3JDQCF9ILSCAVPOJRN0LFS"
    private static let clientIdProd = "P2HHU4CKLS3JDQCF9ILSCAVPOJRN0LFS"
    
    private let baseUrl: String
    private let clientId: String
    public let isMock: Bool

    // Singleton instance
    static let sharedInstance = Config()
    
    override init() {
        let bundle = Bundle(for: type(of: self))
        let scheme = bundle.object(forInfoDictionaryKey: "Scheme") as! String
        isMock = scheme == "Mock"
        baseUrl = Config.baseUrlForScheme(scheme: scheme)
        clientId = Config.clientIdForScheme(scheme: scheme)
        super.init()
    }
    
    private static func baseUrlForScheme(scheme: String) -> String {
        if scheme == "Dev" {
            return Config.devUrl
        } else if scheme == "Staging" {
            return Config.stagingUrl
        } else if scheme == "Production" || scheme == "AppStore" {
            return Config.prodUrl
        }
        return Config.prodUrl
    }
    
    private static func clientIdForScheme(scheme: String) -> String {
        if scheme == "Dev" {
            return Config.clientIdDev
        } else if scheme == "Staging" {
            return Config.clientIdStaging
        }
        return Config.clientIdProd
    }
}

extension Config {
    func apiEndpoint() -> String {
        return baseUrl
    }
    
    func apiClientId() -> String {
        return clientId
    }
    
}
