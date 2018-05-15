//
//  GMSnappedPoints.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 5/8/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import ObjectMapper

class GMSnappedPoints: Mappable {
    
    var snappedPoints: [GMSnappedPoint]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        snappedPoints <- map["snappedPoints"]
    }
}
