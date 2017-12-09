//
//  MappableDataObject.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 12/7/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import ObjectMapper
 
class MappableDataObject<T: Mappable>: Mappable {
    var result: T?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        result <- map["data"]
    }
 }
