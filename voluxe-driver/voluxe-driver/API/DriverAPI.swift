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
        self.host = UserDefaults.standard.apiHost
    }

    override func updateHeaders() {
        super.updateHeaders()
        self.headers["X-CLIENT-ID"] = self.host.clientId
        self.headers["x-application-version"] = "luxe_by_volvo_driver_ios:\(Bundle.current.version)"
    }
}
