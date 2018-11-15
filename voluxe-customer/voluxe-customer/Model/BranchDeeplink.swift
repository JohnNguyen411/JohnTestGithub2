//
//  BranchDeeplink.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 6/4/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class BranchDeeplink: NSObject, Codable {

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
    
    
    /*
    func mapping(map: Map) {
        email <- map["email"]
        phoneNumber <- map["phone_number"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        referringLink <- map["~referring_link"]
        isFirstSession <- map["+is_first_session"]
        id <- map["~id"]
        clickedBranchLink <- map["+clicked_branch_link"]
        marketingTitle <- map["$marketing_title"]
        channel <- map["~channel"]
        campain <- map["~campain"]
        feature <- map["~feature"]
    }
    */

}
