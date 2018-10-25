//
//  BookingFeedback.swift
//  voluxe-driver
//
//  Created by Christoph on 10/24/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation

struct BookingFeedback: Codable {
    let id: Int
    let customer_id: Int
    let booking_id: Int
    let rating: String
    let comment: String
}
