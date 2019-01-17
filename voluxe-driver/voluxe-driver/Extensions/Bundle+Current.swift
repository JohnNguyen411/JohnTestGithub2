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
    /// correct Bundle instance for any target that includes this file.
    static var current: Bundle {
        return Bundle(for: LuxeBundle.self)
    }
}

/// This is the class definition that will scope Bundle.current
/// (and the associated info.plist) to whatever target is running.
fileprivate class LuxeBundle: Bundle {}
