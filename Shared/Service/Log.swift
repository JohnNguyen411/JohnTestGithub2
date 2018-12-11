//
//  Log.swift
//  voluxe-driver
//
//  Created by Christoph on 12/6/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation

// TODO https://app.asana.com/0/858610969087925/935159618076287/f
// TODO finish
class Log {

    enum Reason: String {
        case apiError
        case locationError
        case missingArgument
        case missingValue
    }

    // prevent instancing
    private init() {}

    static func info(_ string: String) {
        NSLog("\nLOG:INFO: \(string)")
    }

    static func unexpected(_ reason: Reason, _ detail: String? = nil) {
        NSLog("\nLOG:UNEXPECTED: \(reason.rawValue) \(detail ?? "")")
    }

    // TODO fatal or assert?
    static func fatal(_ reason: Reason, _ detail: String? = nil) {
        NSLog("\nLOG:FATAL: \(reason.rawValue) \(detail ?? "")")
    }
}
