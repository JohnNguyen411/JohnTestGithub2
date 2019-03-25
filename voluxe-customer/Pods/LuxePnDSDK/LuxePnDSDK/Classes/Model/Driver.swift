//
//  Driver.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/15/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

@objcMembers public class Driver: NSObject, Codable {
    
    public dynamic var id: Int = -1
    public dynamic var name: String?
    public dynamic var iconUrl: String?
    public dynamic var location: Location?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name = "first_name"
        case iconUrl = "photo_url"
        case location
    }
   
}
