//
//  Errors.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 2/23/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import Alamofire

class Errors: Error {
    
    // for all error code, see docs: https://development-docs.ingress.luxe.com/v1/docs/#/
    public enum ErrorCode: String {
        case E2001 = "E2001"
        case E2002 = "E2002"
        case E2003 = "E2003"
        case E2004 = "E2004"
        case E2005 = "E2005"
        case E3001 = "E3001"
        case E3002 = "E3002"
        case E3003 = "E3003"
        case E3004 = "E3004"
        case E3005 = "E3005"
        case E3006 = "E3006"
        case E3011 = "E3011"
        case E4001 = "E4001"
        case E4002 = "E4002"
        case E4003 = "E4003"
        case E4004 = "E4004"
        case E4005 = "E4005"
        case E4006 = "E4006"
        case E4007 = "E4007"
        case E4008 = "E4008"
        case E4009 = "E4009"
        case E4010 = "E4010"
        case E4011 = "E4011"
        case E4012 = "E4012"
        case E4013 = "E4013"
        case E4014 = "E4014"
        case E4015 = "E4015"
        case E4016 = "E4016"
        case E4017 = "E4017"
        case E4018 = "E4018"
        case E4019 = "E4019"
        case E4020 = "E4020"
        case E4021 = "E4021"
        case E4022 = "E4022"
        case E4023 = "E4023"
        case E4046 = "E4046"
        case E4049 = "E4049"
        case E4050 = "E4050"
        case E5001 = "E5001"
        case E5002 = "E5002"
    }
    
    public var afError: AFError? = nil
    public let apiError: ResponseError?
    public var statusCode: Int = 200
    
    init(dataResponse: DataResponse<Any>, apiError: ResponseError?) {
        if let afError = dataResponse.error {
            self.afError = Errors.safeAFError(error: afError)
        }
        if let httpUrlResponse = dataResponse.response {
            statusCode = httpUrlResponse.statusCode
        }
        self.apiError = apiError
    }
    
    public static func safeAFError(error: Error) -> AFError {
        if let aferror = error as? AFError {
            return aferror
        } else {
            let reason = AFError.ResponseValidationFailureReason.unacceptableStatusCode(code: 500)
            return .responseValidationFailed(reason: reason)
        }
    }
}
