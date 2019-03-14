//
//  BookingFeedback.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 6/25/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

@objcMembers public class BookingFeedback: NSObject, Codable {
    
    dynamic var id: Int = -1
    dynamic var bookingId: Int = -1
    dynamic var rating: Int = -1
    dynamic var comment: String?
    dynamic var state: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case bookingId = "booking_id"
        case rating
        case comment
        case state
    }
    
    convenience required public init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        self.bookingId = try container.decodeIfPresent(Int.self, forKey: .bookingId) ?? -1
        self.state = try container.decodeIfPresent(String.self, forKey: .state) ?? ""
        self.comment = try container.decodeIfPresent(String.self, forKey: .comment) ?? ""
        self.rating = try container.decodeIfPresent(Int.self, forKey: .rating) ?? -1
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(bookingId, forKey: .bookingId)
        try container.encodeIfPresent(state, forKey: .state)
        try container.encodeIfPresent(comment, forKey: .comment)
        try container.encodeIfPresent(rating, forKey: .rating)
    }
    
    public func needsRating() -> Bool {
        return state != nil && state! == "pending"
    }
    
}
