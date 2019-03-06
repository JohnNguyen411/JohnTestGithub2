//
//  BookingFeedback.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 6/25/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import CoreLocation
import RealmSwift
import Realm

@objcMembers class BookingFeedback: Object, Codable {
    
    dynamic var id: Int = -1
    dynamic var bookingId: Int = -1
    dynamic var rating: RealmOptional<Int> = RealmOptional<Int>()
    dynamic var comment: String?
    dynamic var state: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case bookingId = "booking_id"
        case rating
        case comment
        case state
    }

    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        self.bookingId = try container.decodeIfPresent(Int.self, forKey: .bookingId) ?? -1
        self.state = try container.decodeIfPresent(String.self, forKey: .state) ?? ""
        self.comment = try container.decodeIfPresent(String.self, forKey: .comment) ?? ""
        self.rating = try container.decodeIfPresent(RealmOptional<Int>.self, forKey: .rating) ?? RealmOptional<Int>()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(bookingId, forKey: .bookingId)
        try container.encodeIfPresent(state, forKey: .state)
        try container.encodeIfPresent(comment, forKey: .comment)
        try container.encodeIfPresent(rating, forKey: .rating)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    public func needsRating() -> Bool {
        return state != nil && state! == "pending"
    }
    
}
