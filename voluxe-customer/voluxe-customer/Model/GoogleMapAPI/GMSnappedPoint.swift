//
//  GMSnappedPoint.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 5/8/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import ObjectMapper

class GMSnappedPoint: Mappable {
    
    var location: GMLocation?
    var originalIndex: Int?
    var placeId: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        location <- map["location"]
        originalIndex <- map["originalIndex"]
        placeId <- map["placeId"]
    }
}
