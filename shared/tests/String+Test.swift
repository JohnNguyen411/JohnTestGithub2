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

/// This (admittedly) is a little sneaky.  The Customer project defines
/// an NSLocalizedString extension to skip the comment argument.  The
/// UI test target needs that same extension to use localized strings,
/// necessary for looking up fields by placeholder name, but the Bundle
/// that NSLocalizedString uses is not the same as the Customer app
/// Bundle.  So this extension makes the target conform to the localizations
/// declared in the Customer target.
///
/// Downside to this method is that if the extension signature changes
/// in the Customer app, the tests will break and this signature will
/// need to be updated.
func NSLocalizedString(_ key: String) -> String {
    let bundle = Bundle(for: BotUserData.self)
    return NSLocalizedString(key, bundle: bundle, comment: "")
}
