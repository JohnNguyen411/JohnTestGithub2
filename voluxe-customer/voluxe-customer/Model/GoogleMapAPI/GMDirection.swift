//
//  GMDirection.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/16/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import ObjectMapper

class GMDirection: NSObject, Mappable {
    
    var routes: [GMRoutes]?
    var status: String?
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        routes = map["routes"].currentValue as? [GMRoutes]
        status = map["status"].currentValue as? String
    }
    
    func mapping(map: Map) {
        routes <- map["routes"]
        status <- map["status"]
    }
    
    func getEta() -> GMTextValueObject? {
        guard let routes = routes else { return nil}
        if routes.count == 0 { return nil }
        
        guard let legs = routes[0].legs else { return nil}
        if legs.count == 0 { return nil }

        guard let duration = legs[0].duration else { return nil}
        return duration
    }
}
