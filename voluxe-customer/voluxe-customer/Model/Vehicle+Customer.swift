//
//  Vehicle+Customer.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 3/14/19.
//  Copyright © 2019 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import LuxePnDSDK

extension Vehicle {
    
    func vehicleDescription() -> String {
        if let color = color, color.count > 0 {
            return "\(color.capitalizingFirstLetter()) \(year) \(model ?? String.localized(.unknown))"
        }
        return "\(baseColor?.capitalizingFirstLetter() ?? "") \(year) \(model ?? String.localized(.unknown))"
    }
    
    
    func mileage() -> Int {
        return 13605
    }
    
    func localImageName() -> String {
        if model == "XC40" {
            return "image_xc40"
        }
        return "image_auto"
    }
    
    func setVehicleImage(imageView: UIImageView) {
        
        if let imageUrl = photoUrl, !imageUrl.isEmpty {
            let url = URL(string: imageUrl)
            imageView.kf.setImage(with: url)
        } else {
            imageView.image = UIImage(named: localImageName())
        }
    }
}
