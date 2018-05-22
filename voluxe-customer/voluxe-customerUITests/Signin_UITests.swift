//
//  FTUEFlow_UITests.swift
//  voluxe-customerUITests
//
//  Created by Giroux, Johan on 11/22/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import XCTest

class SignIn_UITests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func test00_loginAndLogout() {

        let app = XCUIApplication()
        app.launchArguments = ["logoutOnLaunch", "testMode"]
        app.launch()
        self.wait()

        self.loginToVehicleScreen(app)
        self.logout(app)
    }

    func test01_loginAndQuit() {

        let app = XCUIApplication()
        app.launchArguments = ["testMode"]
        app.launch()
        self.wait(for: 5, label: "waiting for app to log in")

        self.loginToVehicleScreen(app)
    }

    func test02_autoLoginOnLaunch() {

        let app = XCUIApplication()
        app.launchArguments = ["testMode"]
        app.launch()
        self.wait(for: 5, label: "waiting for app to log in")

        XCTAssertTrue(app.staticTexts["Your Volvo"].exists)
    }
}
