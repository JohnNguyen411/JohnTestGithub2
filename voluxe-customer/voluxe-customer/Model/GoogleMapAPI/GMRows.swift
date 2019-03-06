//
//  GMRows.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 5/4/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class GMRows: Codable {
    
    let elements: [GMElements]?
    
    private enum CodingKeys: String, CodingKey {
        case elements
    }
    
}
