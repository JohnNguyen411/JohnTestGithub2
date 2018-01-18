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
    
    func mapping(map: Map) {
        error <- map["error"]
        code <- map["code"]
        message <- map["message"]
    }
    
    
}
