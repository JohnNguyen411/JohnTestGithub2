//
//  ResponseObject.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 12/7/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class ResponseObject<T: Mappable> {
    
    init(json: [String: Any]) {
        if let jsonMeta = json["meta"] as? [String: Any] {
            meta = Meta(JSON: jsonMeta)
        }
        data = Mapper<T>().map(JSON: json)
    }
    
    var meta: Meta?
    var data: T?
    
    
}
