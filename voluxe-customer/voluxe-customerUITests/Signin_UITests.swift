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
        UIView.setAnimationsEnabled(false)
    }

    func test00_loginAndLogout() {

        let app = XCUIApplication()
        app.launchArguments = ["logoutOnLaunch", "testMode"]
        app.launch()
        self.wait(for: 10, label: "waiting for app to log in")

        self.loginToVehicleScreen(app)
        self.logout(app)
    }

    func test01_loginAndQuit() {

        let app = XCUIApplication()
        app.launchArguments = ["testMode"]
        app.launch()
        self.wait(for: 10, label: "waiting for app to log in")

        self.loginToVehicleScreen(app)
    }

    func test02_autoLoginOnLaunch() {

        let app = XCUIApplication()
        app.launchArguments = ["testMode"]
        app.launch()
        self.wait(for: 10, label: "waiting for app to log in")

        XCTAssertTrue(app.otherElements["Pickup & Delivery"].exists)
    }
}

extension XCTestCase {

    func loginToVehicleScreen(_ app: XCUIApplication) {

        XCTAssertTrue(app.buttons["CREATE ACCOUNT"].exists)
        app.buttons["SIGN-IN"].tap()
        self.wait()

        var textField = app.textFields[String.EmailPlaceholder]
        textField.tap()
        textField.typeText(BotUserData.email)

        textField = app.otherElements["volvoPwdTextField"]
        textField.tap()
        textField.typeText(BotUserData.password)

        app.navigationBars.firstMatch.buttons["Next"].tap()
        self.wait(for: 10, label: "logging in")

        XCTAssertTrue(app.otherElements["Pickup & Delivery"].exists)
    }

    func logout(_ app: XCUIApplication) {

        app.navigationBars.firstMatch.buttons["ic menu"].tap()
        self.wait()

        app.otherElements["leftViewController"].staticTexts["Sign Out"].tap()
        self.wait()

        app.alerts["Sign Out"].buttons["Sign Out"].tap()
        self.wait()

        XCTAssertTrue(app.buttons["SIGN-IN"].exists)
        XCTAssertTrue(app.buttons["CREATE ACCOUNT"].exists)
    }
}
