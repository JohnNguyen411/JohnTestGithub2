//
//  BranchDeeplink.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 6/4/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class BranchDeeplink: Codable {

    var email: String?
    var phoneNumber: String?
    var firstName: String?
    var lastName: String?
    var referringLink: String?
    var isFirstSession: Bool?
    var id: String?
    var clickedBranchLink: Bool?
    var marketingTitle: String?
    var channel: String?
    var campain: String?
    var feature: String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "~id"
        case email
        case phoneNumber = "phone_number"
        case firstName = "first_name"
        case lastName = "last_name"
        case referringLink = "~referring_link"
        case isFirstSession = "+is_first_session" //TODO check nested object parsin
        case clickedBranchLink = "+clicked_branch_link"
        case marketingTitle = "$marketing_title"
        case channel = "~channel"
        case campain = "~campain" 
        case feature = "~feature" 
    }

    static func decode<T: Decodable>(data: Data?, reportErrors: Bool = true) -> T? {
        guard let data = data else { return nil }
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.localISO8601)
            let object = try decoder.decode(T.self, from: data)
            return object
        } catch {
            // TODO log to console?
            if reportErrors { NSLog("\n\nDECODE ERROR: \(error)\n\n") }
            return nil
        }
    }

}
