//
//  GMSnappedPoint.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 5/8/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import ObjectMapper

class GMSnappedPoint: NSObject, Mappable {
    
    var location: GMLocation?
    var originalIndex: Int?
    var placeId: String?
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        location = map["location"].currentValue as? GMLocation
        originalIndex = map["originalIndex"].currentValue as? Int
        placeId = map["placeId"].currentValue as? String
    }
    
    func mapping(map: Map) {
        location <- map["location"]
        originalIndex <- map["originalIndex"]
        placeId <- map["placeId"]
    }
}
