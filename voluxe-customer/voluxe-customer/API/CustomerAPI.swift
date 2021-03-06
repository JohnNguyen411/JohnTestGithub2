//
//  CustomerAPI.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 11/15/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

extension RestAPIHost {
    
    var clientId: String {
        switch self {
        case .development: return "P2HHU4CKLS3JDQCF9ILSCAVPOJRN0LFS"
        case .staging: return "SZO87U0WG2LIZBKKV6E16S5PHAHU6ERJ"
        case .production: return "3K0M02Z9KT3FAEENWXS07X54AN2427Q5"
        }
    }
}


class CustomerAPI: LuxeAPI {
    
    static let api = CustomerAPI()
    
    private override init() {
        super.init()
        self.host = UserDefaults.standard.apiHost ?? .development
    }
    
    static func initToken(token: String) {
        self.api.initToken(token: token)
    }
    
    override func updateHeaders() {
        super.updateHeaders()
        self.headers["X-CLIENT-ID"] = self.host.clientId
        #if DEBUG
        self.headers["x-application-version"] = "luxe_by_volvo_customer_ios:\(Bundle(for: type(of: self)).version)"
        #else
        self.headers["x-application-version"] = "luxe_by_volvo_customer_ios:\(Bundle.main.version)"
        #endif
    }
}
