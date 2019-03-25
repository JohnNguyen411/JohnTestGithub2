//
//  CustomerAPI+Customer.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 3/25/19.
//  Copyright © 2019 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

extension CustomerAPI {
    
    static func reloadHost() {
        self.api.host = UserDefaults.standard.apiHost
    }
    
}
