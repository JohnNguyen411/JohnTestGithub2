//
//  DriverManager+Dealerships.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 1/24/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation

extension DriverManager {
    
    func dealership(for id: Int) -> Dealership? {
        guard let dealerships = self.dealerships else {
            return nil
        }
        for dealership in dealerships {
            if dealership.id == id {
                return dealership
            }
        }
        return nil
    }
    
}
