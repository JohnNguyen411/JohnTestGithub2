//
//  ResponseError.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 1/18/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import ObjectMapper

class ResponseError: Mappable {
    
    var error: Bool?
    var code: String?
    var message: String?
    
    required init?(map: Map) {
    }
    
    init() {
    }
    
    func mapping(map: Map) {
        error <- map["error"]
        code <- map["code"]
        message <- map["message"]
    }
    
    func getCode() -> Errors.ErrorCode? {
        if let code = code {
            return Errors.ErrorCode(rawValue: code)
        }
        return nil
    }
    
    static func emptyDataError() -> ResponseError {
        let responseError = ResponseError()
        responseError.code = Errors.ErrorCode.E5001.rawValue
        responseError.error = true
        return responseError
    }
}
