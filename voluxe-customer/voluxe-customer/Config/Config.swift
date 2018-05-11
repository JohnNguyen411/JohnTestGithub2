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
    
    private static let googleAPIDebugKey = "AIzaSyCf1Ub4aMgqWeISdHPEcFawx-N-OrmxBTM"
    private static let googleAPIReleaseKey = "AIzaSyA65M4H5PG82NbkDRcTmvq9ouqAZJKCil8"
    
    private static let releaseBundleId = "com.volvocars.luxebyvolvo"
    
    private static let devUrl = "https://development-uswest2.api.luxe.com"
    private static let stagingUrl = "https://development-uswest2.api.luxe.com"
    private static let prodUrl = "https://development-uswest2.api.luxe.com"
    
    private static let clientIdDev = "P2HHU4CKLS3JDQCF9ILSCAVPOJRN0LFS"
    private static let clientIdStaging = "P2HHU4CKLS3JDQCF9ILSCAVPOJRN0LFS"
    private static let clientIdProd = "P2HHU4CKLS3JDQCF9ILSCAVPOJRN0LFS"
    
    private let baseUrl: String
    private let clientId: String
    private let googleMapsAPIKey: String
    public let isMock: Bool

    // Singleton instance
    static let sharedInstance = Config()
    
    override init() {
        let bundle = Bundle(for: type(of: self))
        let scheme = bundle.object(forInfoDictionaryKey: "Scheme") as! String
        isMock = scheme == "Mock"
        baseUrl = Config.baseUrlForScheme(scheme: scheme)
        clientId = Config.clientIdForScheme(scheme: scheme)
        if scheme == Config.releaseBundleId {
            googleMapsAPIKey = "AIzaSyA65M4H5PG82NbkDRcTmvq9ouqAZJKCil8"
        } else {
            googleMapsAPIKey = "AIzaSyCf1Ub4aMgqWeISdHPEcFawx-N-OrmxBTM"
        }
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
    
    func mapAPIKey() -> String {
        return googleMapsAPIKey
    }
    
}
