//
//  LuxeAPI+Version.swift
//  voluxe-driver
//
//  Created by Christoph on 11/1/18.
//  Copyright © 2018 Volvo Valet. All rights reserved.
//

import Foundation

// Defines an inner class suited to handling an API response
// that should generate LuxeAPI notifications.  This works in
// tandem with LuxeAPI+Notifications.
extension LuxeAPI {

    class Version: CustomStringConvertible {

        private let value: String

        init(value: String?) {
            var safeValue = value ?? "unknown"
            safeValue = safeValue.isEmpty ? "unknown" : safeValue
            self.value = safeValue
        }

        var isUnknown: Bool {
            return self.value == "unknown"
        }

        var isKnown: Bool {
            return self.value != "unknown"
        }

        var description: String {
            return self.value
        }

        func isNewer(than version: Version) -> Bool {
            guard self.isKnown else { return false }
            if version.isUnknown { return true }
            let newer = self.description.compare(version.description, options: .numeric) == .orderedDescending
            return newer
        }
    }
}

extension LuxeAPI.Version: Equatable {

    static func == (lhs: LuxeAPI.Version, rhs: LuxeAPI.Version) -> Bool {
        return lhs.description == rhs.description
    }
}

extension HTTPURLResponse {

    func updateAvailable() -> Bool {
        let header = self.allHeaderFields["x-luxe-application-upgrade-available"] as? String
        let available = NSString(string: header ?? "").boolValue
        return available
    }

    func applicationVersion() -> LuxeAPI.Version {
        let header = self.allHeaderFields["x-luxe-application-latest-version"] as? String
        let version = LuxeAPI.Version(value: header)
        return version
    }
}
