//
//  GMSAddress.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 5/3/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation


extension GMSAddress {
    
    func fullAddress() -> String {
        
        var fullAddress = shortAddress()
        
        if let postalCode = self.postalCode, let administrativeArea = self.administrativeArea {
            fullAddress += ", \(postalCode) \(administrativeArea)"
        }
        
        if let country = self.country {
            fullAddress += ", \(country)"
        }
        
        return fullAddress
    }
    
    func shortAddress() -> String {
        
        var shortAddress = ""
        if let thoroughfare = self.thoroughfare {
            shortAddress += thoroughfare
        }
        if let locality = self.locality {
            shortAddress += ", \(locality)"
        }
        
        return shortAddress
    }
    
}
