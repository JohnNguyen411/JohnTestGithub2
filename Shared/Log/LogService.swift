//
//  Log.swift
//  voluxe-driver
//
//  Created by Christoph on 12/6/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation

enum LogReason: String {
    case apiError
    case locationError
    case missingArgument
    case missingValue
    case incorrectValue
}

/// A protocol that defines a stateless log API for use across
/// all layers of an application.  Clients are encouraged to
/// define `Log` to point to a specific implementation, like
/// `typealias Log = OSLog`.  This allows the implementation
/// to be changed on a per target level based on needs.
protocol LogService {
    static func info(_ string: String)
    static func unexpected(_ reason: LogReason, _ detail: String?)
    static func fatal(_ reason: LogReason, _ detail: String?)
}
