//
//  Log+Analytics.swift
//  voluxe-driver
//
//  Created by Christoph on 1/29/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation

/// A LogService implementation that mirrors messages to the
/// Analytics service AND the OSLog.
class LogAnalytics: LogService {

    static func info(_ string: String) {
        Analytics.log(.info, string)
        OSLog.info(string)
    }

    static func unexpected(_ reason: LogReason, _ detail: String? = nil) {
        Analytics.log(.unexpected, "\(reason.rawValue) \(detail ?? "")")
        OSLog.unexpected(reason, detail)
    }

    static func fatal(_ reason: LogReason, _ detail: String? = nil) {
        Analytics.log(.fatal, "\(reason.rawValue) \(detail ?? "")")
        OSLog.fatal(reason, detail)
    }
}
