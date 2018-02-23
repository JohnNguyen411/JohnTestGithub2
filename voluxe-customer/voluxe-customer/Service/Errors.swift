//
//  Errors.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 2/23/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import Alamofire

class Errors {
    
    
    public static func safeAFError(error: Error) -> AFError {
        if let aferror = error as? AFError {
            return aferror
        } else {
            let reason = AFError.ResponseValidationFailureReason.unacceptableStatusCode(code: 500)
            return .responseValidationFailed(reason: reason)
        }
    }
}
