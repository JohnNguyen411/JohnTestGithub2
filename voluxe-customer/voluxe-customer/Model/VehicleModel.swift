//
//  VehicleModel.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 3/1/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class VehicleModel: NSObject, Codable {
    
    dynamic var id: Int = -1
    dynamic var make: String?
    dynamic var name: String?
    dynamic var managed: Bool = true
    dynamic var createdAt: Date?
    dynamic var updatedAt: Date?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case make
        case name
        case managed
        case createdAt = "created_at" 
        case updatedAt = "updated_at" 
    }
    
    convenience init(make: String, model: String) {
        self.init()
        self.make = make
        self.name = model
    }
    
   
}
