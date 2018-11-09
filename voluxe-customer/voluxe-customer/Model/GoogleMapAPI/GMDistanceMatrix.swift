//
//  GMDistanceMatrix.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 5/4/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class GMDistanceMatrix: Codable {
    
    let rows: [GMRows]?
    let status: String?

    /*
    func mapping(map: Map) {
        rows <- map["rows"]
        status <- map["status"]
    }
    */
    
    func getEta() -> GMTextValueObject? {
        guard let rows = rows else { return nil}
        if rows.count == 0 { return nil }
        
        guard let elements = rows[0].elements else { return nil}
        if elements.count == 0 { return nil }
        
        guard let duration = elements[0].duration else { return nil}
        return duration
    }
}
