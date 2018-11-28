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
    let customerId: Int
    let bookingId: Int
    let rating: String
    let comment: String

    enum CodingKeys: String, CodingKey {
        case id
        case customerId = "customer_id"
        case bookingId = "booking_id"
        case rating
        case comment
    }
}
