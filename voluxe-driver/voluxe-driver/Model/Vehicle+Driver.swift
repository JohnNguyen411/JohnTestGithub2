//
//  Vehicle+Driver.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 4/1/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation

extension Vehicle {
    
    func vehicleDescription() -> String {
        if let color = color, color.count > 0 {
            return "\(color.capitalizingFirstLetter()) \(year ) \(model ?? Unlocalized.unknown)"
        }
        return "\(baseColor?.capitalizingFirstLetter() ?? "") \(year ) \(model ?? Unlocalized.unknown)"
    }
    
}
