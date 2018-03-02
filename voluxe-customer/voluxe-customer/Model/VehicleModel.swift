//
//  VehicleModel.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 3/1/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class VehicleModel: NSObject {
    
    let make: String
    let model: String
    
    init(make: String, model: String) {
        self.make = make
        self.model = model
        super.init()
    }
}
