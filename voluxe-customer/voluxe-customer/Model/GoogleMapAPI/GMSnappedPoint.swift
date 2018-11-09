//
//  GMSnappedPoint.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 5/8/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class GMSnappedPoint: Codable {
    
    var location: GMLocation?
    var originalIndex: Int?
    var placeId: String?
   
    /*
    func mapping(map: Map) {
        location <- map["location"]
        originalIndex <- map["originalIndex"]
        placeId <- map["placeId"]
    }
 */
}
