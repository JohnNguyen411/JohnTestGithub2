//
//  Bundle+Voluxe.swift
//  voluxe-customer
//
//  Created by Christoph on 5/1/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

extension Bundle {

    var version: String {
        let version = self.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        return version
    }

    var build: String {
        let build = self.infoDictionary?["CFBundleVersion"] as? String ?? ""
        return build
    }

    /// Returns a string from the bundle version and short version
    /// formatted as 1.2.3 (123).
    var versionAndBuild: String {
        return "\(self.version) (\(self.build))"
    }

    /// Returns a String indicating which build scheme this bundle
    /// was built with.  The scheme is used to select the correct
    /// server environment for the app. Checkout Config:baseUrlForScheme()
    /// for how it is used.
    ///
    /// If the bundle's Info.plist does not have a "Scheme" value, then
    /// this will assert in debug and default to "Dev" in release builds.
    var scheme: String {
        if let scheme = self.object(forInfoDictionaryKey: "Scheme") as? String {
            return scheme
        } else {
            return "Development"
        }
    }
}
