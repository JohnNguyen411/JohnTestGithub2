//
//  GMSnappedPoints.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 5/8/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import ObjectMapper

class GMSnappedPoints: NSObject, Mappable {
    
    var snappedPoints: [GMSnappedPoint]?
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        snappedPoints = map["snappedPoints"].currentValue as? [GMSnappedPoint]
    }
    
    func mapping(map: Map) {
        snappedPoints <- map["snappedPoints"]
    }
    
}
