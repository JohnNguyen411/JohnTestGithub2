//
//  UserDefaults+LuxeAPI.swift
//  voluxe-driver
//
//  Created by Christoph on 11/1/18.
//  Copyright © 2018 Volvo Valet. All rights reserved.
//

import Foundation

extension UserDefaults {

    // TODO is this the right component, feels a little odd
    func shouldShowUpdate(for version: LuxeAPI.Version) -> Bool {
        guard version.isKnown else { return false }
        let checkedVersion = self.checkedVersion ?? LuxeAPI.Version(value: Bundle.main.version)
        guard version.isNewer(than: checkedVersion) else { return false }
        self.checkedVersion = version
        return true
    }

    private var checkedVersion: LuxeAPI.Version? {
        get {
            let string = self.string(forKey: #function)
            return LuxeAPI.Version(value: string)
        }
        set {
            self.set(newValue?.description, forKey: #function)
            self.synchronize()
        }
    }

    var injectLoginRequired: Bool {
        get {
            return self.bool(forKey: #function)
        }
        set {
            self.set(newValue, forKey: #function)
        }
    }

    var injectUpdateRequired: Bool {
        get {
            return self.bool(forKey: #function)
        }
        set {
            self.set(newValue, forKey: #function)
        }
    }

    var apiHost: RestAPIHost {
        get {
            #if DEBUG
                let rawValue = self.string(forKey: #function) ?? ""
                let host = RestAPIHost(rawValue: rawValue)
                return host ?? RestAPIHost.development
            #else
                return RestAPIHost.production
            #endif
        }
        set {
            #if DEBUG
                self.set(newValue.rawValue, forKey: #function)
            #endif
        }
    }
}
