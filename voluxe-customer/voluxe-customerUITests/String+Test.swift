//
//  String+Test.swift
//  voluxe-customerUITests
//
//  Created by Christoph on 5/17/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

extension String {

    static func uniqueEmailString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd-HH.mm.ss"
        let dateString = formatter.string(from: Date())
        let string = "bot-\(dateString)@luxe.com"
        return string
    }

    static func uniquePhoneNumberString() -> String {
        let string = "+1415555\(Int.random(from: 1000, to: 9999))"
        return string
    }

    static func uniquePassword() -> String {
        return "TestPassword\(Int.random(from: 1000, to: 9999))"
    }
}
