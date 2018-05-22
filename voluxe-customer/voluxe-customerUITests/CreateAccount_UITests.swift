//
//  SignUp_UITests.swift
//  voluxe-customerUITests
//
//  Created by Christoph on 5/21/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import XCTest

class CreateAccount_UITests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    // MARK:- Utilities

    func test00_loginAsAdminAndGetVerificationCode() {

        // this was an account manually created but never verified
        // eventually the token will expire but for the moment this
        // is a handy way to test the admin verification API
        let customerEmail = "bot-1234567890@luxe.com"
        AdminAPI.loginAndRequestVerificationCode(for: customerEmail) {
            code in
            XCTAssertNil(code?.usedAt)
            XCTAssertNotNil(code)
        }
        self.wait(for: 10, label: "getting verification code")
    }

    // MARK:- Sign up complete happy path

    func test10_signUp() {

        let app = XCUIApplication()
        app.launchArguments = ["logoutOnLaunch", "testMode"]
        app.launch()
        self.wait()

        XCTAssertTrue(app.buttons["SIGN-IN"].exists)
        app.buttons["CREATE ACCOUNT"].tap()
        self.wait()

        var textField = app.textFields["Johan"]
        textField.tap()
        textField.typeText(BotUserData.firstName)

        textField = app.textFields["Johansson"]
        textField.tap()
        textField.typeText(BotUserData.lastName)

        app.navigationBars.firstMatch.buttons["Next"].tap()
        self.wait()

        textField = app.textFields["name@domain.com"]
        textField.tap()
        textField.typeText(BotUserData.email)

        textField = app.textFields["(555) 555-5555"]
        textField.tap()
        textField.typeText(BotUserData.phone)

        app.navigationBars.firstMatch.buttons["Next"].tap()
        self.wait()

        AdminAPI.loginAndRequestVerificationCode(for: BotUserData.email) {
            code in
            XCTAssertNotNil(code, "expected verification code is nil")
            XCTAssertNil(code?.usedAt, "verification code has already been used")
            app.textFields["0000"].typeText("\(code?.value ?? "")")
        }
        self.wait(for: 5, label: "getting verification code")

        app.navigationBars.firstMatch.buttons["Next"].tap()
        self.wait()

        textField = app.otherElements["volvoPwdTextField"]
        textField.tap()
        textField.typeText(BotUserData.password)

        textField = app.otherElements["volvoPwdConfirmTextField"]
        textField.tap()
        textField.typeText(BotUserData.password)

        app.navigationBars.firstMatch.buttons["Next"].tap()
        self.wait(for: 10, label: "waiting for verification code to be accepted")

        app.textFields["2018"].tap()
        app.toolbars["Toolbar"].buttons["Done"].tap()
        self.wait()

        app.textFields["S90"].tap()
        app.toolbars["Toolbar"].buttons["Done"].tap()
        self.wait()

        app.textFields["Black"].tap()
        app.toolbars["Toolbar"].buttons["Done"].tap()
        self.wait()

        app.navigationBars.firstMatch.buttons["Done"].tap()
        self.wait(for: 10, label: "waiting for vehicle to be created")

        XCTAssertTrue(app.staticTexts["Your Volvo"].exists)
    }

    // MARK:- Sign up failure paths

    func _test11_signUpSameEmail() {

        let app = XCUIApplication()
        app.launchArguments = ["testMode"]
        app.launch()
        self.wait()
    }
}
