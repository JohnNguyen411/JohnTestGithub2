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

    var versionAndBuild: String {
        return "\(self.version) (\(self.build))"
    }
}
