//
//  Location.swift
//  voluxe-driver
//
//  Created by Christoph on 10/23/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation

// TODO accuracy needed?
// TODO updated_at needed?
struct Location: Codable {
    let address: String
    let latitude: Double
    let longitude: Double
}
