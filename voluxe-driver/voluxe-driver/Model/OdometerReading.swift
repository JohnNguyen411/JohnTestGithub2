//
//  OdometerReading.swift
//  voluxe-driver
//
//  Created by Christoph on 1/15/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation

struct OdometerReading: Codable {
    let id: Int
    let value: Int
    let unit: String
    let taken_by_id: Int
    let taken_by_type: String
}
