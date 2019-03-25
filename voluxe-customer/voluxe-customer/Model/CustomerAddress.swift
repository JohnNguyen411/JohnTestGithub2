//
//  CustomerAddress.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 3/22/19.
//  Copyright © 2019 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import CoreLocation

@objcMembers class CustomerAddress: NSObject {
    
    public dynamic var id = UUID().uuidString
    public dynamic var volvoCustomerId: String?
    public dynamic var location: Location?
    public dynamic var label: String? // Work / Home / Gym etc
    public dynamic var createdAt: Date?
    public dynamic var updatedAt: Date?
    public dynamic var luxeCustomerId: Int = -1
    
    
    convenience init(id: String?) {
        self.init()
        if let id = id {
            self.id = id
        }
    }
}

