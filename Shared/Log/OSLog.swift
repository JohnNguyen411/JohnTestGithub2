//
//  LogService+OSLog.swift
//  voluxe-driver
//
//  Created by Christoph on 1/29/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import os.log

/// LogService implementation built on top of the
/// os.log framework.
/// https://developer.apple.com/documentation/os/logging
class OSLog: LogService {

    static func info(_ string: String) {
        let string = "LOG:INFO: \(string)"
        os_log("%@", type: OSLogType.info, string)
    }

    static func unexpected(_ reason: LogReason, _ detail: String? = nil) {
        let string = "LOG:UNEXPECTED:\(reason.rawValue) \(detail ?? "")"
        os_log("%@", type: OSLogType.error, string)
    }

    static func fatal(_ reason: LogReason, _ detail: String? = nil) {
        let string = "LOG:FATAL:\(reason.rawValue) \(detail ?? "")"
        os_log("%@", type: OSLogType.fault, string)
    }
}
