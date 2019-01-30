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
    let licensePlate: String?
    let make: String
    let model: String
    let drive: String?
    let engine: String?
    let trim: String?
    let year: Int
    let baseColor: String
    let color: String?
    let transmission: String?
    let photoUrl: String
    let latestOdometerReading: OdometerReading?

    enum CodingKeys: String, CodingKey {
        case id
        case vin
        case licensePlate = "license_plate"
        case make
        case model
        case drive
        case engine
        case trim
        case year
        case baseColor = "base_color"
        case color
        case transmission
        case photoUrl = "photo_url"
        case latestOdometerReading = "latest_odometer_reading"
    }
}
