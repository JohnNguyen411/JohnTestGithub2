//
//  LuxeAPIError.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 11/26/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

struct LuxeAPIError: Codable, Error {

    // Luxe API specific error codes that are returned in the meta JSON blob
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
