//
//  Vehicle.swift
//  voluxe-driver
//
//  Created by Christoph on 10/24/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation

struct Vehicle: Codable {
    let id: Int
    let vin: String?
    let license_plate: String?
    let make: String
    let model: String
    let drive: String?
    let engine: String?
    let trim: String?
    let year: Int
    let base_color: String
    let color: String?
    let transmission: String?
    let photo_url: String
    let latest_odometer_reading: String?
}
