//
//  VehicleModel.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 3/1/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

public class VehicleModel: NSObject, Codable {
    
    public var id: Int = -1
    public var make: String?
    public var name: String?
    public var managed: Bool = true
    public var createdAt: Date?
    public var updatedAt: Date?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case make
        case name
        case managed
        case createdAt = "created_at" 
        case updatedAt = "updated_at" 
    }
    
    public convenience init(make: String, model: String) {
        self.init()
        self.make = make
        self.name = model
    }
    
   
}
