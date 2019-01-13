//
//  Bundle+Current.swift
//  voluxe-driver
//
//  Created by Christoph on 1/8/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation

extension Bundle {

    /// Bundle.main returns the bundle for the package app instance,
    /// however this changes for test targets.  There are areas of
    /// the app, like API, that use the bundle for version or schemes
    /// so it is critical that the correct bundle is used.  This is
    /// offered as a workaround to main that will always provide the
    /// correct Bundle instance for any target that includes the LuxeAPI
    /// file.  Since that applies to the app and API test targets, this
    /// works well.  Note that it is included as part of the application
    /// source code and NOT part of Shared.
    static var current: Bundle {
        return Bundle(for: LuxeAPI.self)
    }
}
