//
//  GMElements.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 5/4/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class GMElements: Codable {
    
    let distance: GMTextValueObject?
    let duration: GMTextValueObject?
    
    private enum CodingKeys: String, CodingKey {
        case distance
        case duration
    }

}
