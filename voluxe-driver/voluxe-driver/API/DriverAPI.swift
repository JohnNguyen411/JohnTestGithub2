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

class DriverAPI: LuxeAPI {

    static let api = DriverAPI()

    private override init() {
        super.init()
        
        #if DEBUG
        
        if UserDefaults.standard.apiHost == nil {
            
            let bundleID = Bundle.main.bundleIdentifier

            if bundleID == "com.luxe.luxebyvolvo.agent.development" {
                UserDefaults.standard.apiHost = .development
            } else if bundleID == "com.luxe.luxebyvolvo.agent.staging" {
                UserDefaults.standard.apiHost = .staging
            } else if bundleID == nil { // TESTS Target
                UserDefaults.standard.apiHost = .development
            } else {
                UserDefaults.standard.apiHost = .production
            }
        }
        #endif
        
        self.host = UserDefaults.standard.apiHost ?? .production
    }

    override func updateHeaders() {
        super.updateHeaders()
        self.headers["X-CLIENT-ID"] = self.host.clientId
        self.headers["x-application-version"] = "luxe_by_volvo_driver_ios:\(Bundle.current.version)"
    }
}
