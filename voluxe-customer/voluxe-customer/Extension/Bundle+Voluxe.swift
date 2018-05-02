//
//  Bundle+Voluxe.swift
//  voluxe-customer
//
//  Created by Christoph on 5/1/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

extension Bundle {

    /// Returns the path to the Google Services plist (to init Firebase)
    /// but dependent on the flavor of build.  Look in the project's
    /// "Active Compilation Conditions" build setting to see where
    /// APP_STORE is defined.
    ///
    /// Note that this will assert in debug if either of the plists is
    /// not found.  This is done to ensure that the developer has a chance
    /// to fix the App Store plist without having to run the App Store build.
    static func pathForGoogleServicePlist() -> String? {

        let appStorePath = Bundle.main.path(forResource: "GoogleService-Info-AppStore", ofType: "plist")
        assert(appStorePath != nil)

        let developmentPath = Bundle.main.path(forResource: "GoogleService-Info-Development", ofType: "plist")
        assert(developmentPath != nil)

        #if APP_STORE
            return appStorePath
        #else
            return developmentPath
        #endif
    }
}
