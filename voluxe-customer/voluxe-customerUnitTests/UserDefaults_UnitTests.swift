//
//  UserDefaults_UnitTests.swift
//  voluxe-customerUnitTests
//
//  Created by Christoph on 6/27/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import XCTest

class UserDefaults_UnitTests: XCTestCase {

    func testFirstTimeLaunch() {

        // reset the bundle i.e. defaults first
        guard let defaults = UserDefaults(suiteName: "unitTests") else { XCTFail(); return }
        defaults.removePersistentDomain(forName: "unitTests")
        defaults.synchronize()

        // true for first call, false for next calls
        XCTAssertTrue(defaults.isFirstTimeLaunch)
        XCTAssertFalse(defaults.isFirstTimeLaunch)
    }
}
