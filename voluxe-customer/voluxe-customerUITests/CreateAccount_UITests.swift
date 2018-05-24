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
            XCTAssertNotNil(code)
        }
        self.wait(for: 10, label: "getting verification code")
    }

    func test09_launchAndTapCreateAccount() {

        let app = XCUIApplication()
        app.launchArguments = ["logoutOnLaunch", "testMode"]
        app.launch()
        self.wait(for: 5, label: "waiting for app to finish launching")

        XCTAssertTrue(app.buttons["SIGN-IN"].exists)
        app.buttons["CREATE ACCOUNT"].tap()
        self.wait()

        XCTAssertTrue(app.staticTexts["welcomeLabel"].exists)
    }

    // MARK:- Create account names

    func test10_invalidNames() {

        let app = XCUIApplication()

        let firstNameTextfield = app.textFields["Johan"]
        let lastNameTextfield = app.textFields["Johansson"]
        let next = app.navigationBars.firstMatch.buttons["Next"]

        // next button is disabled by default
        XCTAssertFalse(next.isEnabled)

        // next button is disabled if last is empty
        firstNameTextfield.tap(andType: BotUserData.firstName)
        XCTAssertFalse(next.isEnabled)

        // next button is disabled if first is empty
        firstNameTextfield.tapAndClearText()
        lastNameTextfield.tap(andType: BotUserData.lastName)
        XCTAssertFalse(next.isEnabled)

        // next button should be disabled if fields are cleared
        firstNameTextfield.tapAndClearText()
        lastNameTextfield.tapAndClearText()
        XCTAssertFalse(next.isEnabled)
    }

    func test19_validNames() {

        let app = XCUIApplication()

        var textField = app.textFields["Johan"]
        textField.tapAndClearText()
        textField.typeText(BotUserData.firstName)

        textField = app.textFields["Johansson"]
        textField.tapAndClearText()
        textField.typeText(BotUserData.lastName)

        let next = app.navigationBars.firstMatch.buttons["Next"]
        XCTAssertTrue(next.isEnabled)
        next.tap()
        self.wait()
    }

    // MARK:- Create account contact email and phone number

    func test20_invalidEmailAndPhone() {

        let app = XCUIApplication()

        let emailTextfield = app.textFields["name@domain.com"]
        let phoneTextfield = app.textFields["(555) 555-5555"]
        let next = app.navigationBars.firstMatch.buttons["Next"]

        // next button is disabled by default
        XCTAssertFalse(next.isEnabled)

        // next button is disabled if number is empty
        emailTextfield.tap(andType: BotUserData.email)
        XCTAssertFalse(next.isEnabled)

        // next button is disabled if email is empty
        emailTextfield.tapAndClearText()
        phoneTextfield.tap(andType: BotUserData.phone)
        XCTAssertFalse(next.isEnabled)

        // next button should be disabled if fields are cleared
        emailTextfield.tapAndClearText()
        phoneTextfield.tapAndClearText()
        XCTAssertFalse(next.isEnabled)

        // invalid email format
        phoneTextfield.tapAndClearText()
        phoneTextfield.typeText(BotUserData.phone)
        emailTextfield.tapAndClearText()
        emailTextfield.typeText("bademailnoatsymbol.com")
        XCTAssertFalse(next.isEnabled)
        emailTextfield.tapAndClearText()
        emailTextfield.typeText("bademail@nohostname")
        XCTAssertFalse(next.isEnabled)
        emailTextfield.tapAndClearText()
        emailTextfield.typeText("@nouser.com")
        XCTAssertFalse(next.isEnabled)
        emailTextfield.tapAndClearText()
        emailTextfield.typeText("😶🍩💨@emoji.com")
        XCTAssertFalse(next.isEnabled)

        // invalid phone format
        emailTextfield.tapAndClearText()
        emailTextfield.typeText(BotUserData.email)
        phoneTextfield.tapAndClearText()
        phoneTextfield.typeText("abcdefghijk")
        XCTAssertFalse(next.isEnabled)
        phoneTextfield.tapAndClearText()
        phoneTextfield.typeText("415ghj5678")
        XCTAssertFalse(next.isEnabled)
        phoneTextfield.tapAndClearText()
        phoneTextfield.typeText("415😶🍩💨5678")
        XCTAssertFalse(next.isEnabled)

        // valid phone format because some characters are ignored
        phoneTextfield.tapAndClearText()
        phoneTextfield.typeText("415😶🍩💨555abc9999")
        XCTAssertTrue(next.isEnabled)
    }

    func test21_validEmailAndPhone() {

        let app = XCUIApplication()

        var textField = app.textFields["name@domain.com"]
        textField.tapAndClearText()
        textField.typeText(BotUserData.email)

        textField = app.textFields["(555) 555-5555"]
        textField.tapAndClearText()
        textField.typeText(BotUserData.phone)

        let next = app.navigationBars.firstMatch.buttons["Next"]
        XCTAssertTrue(next.isEnabled)
        next.tap()
        self.wait()
    }

    // MARK:- Verify phone number

    func test30_invalidVerificationCode() {

        let app = XCUIApplication()
        let field = app.textFields["0000"]
        let next = app.navigationBars.firstMatch.buttons["Next"]

        // too short 0 to 3 characters
        XCTAssertFalse(next.isEnabled)
        field.tap(andType: "1")
        XCTAssertFalse(next.isEnabled, "code is too short")
        field.typeText("2")
        XCTAssertFalse(next.isEnabled, "code is too short")
        field.typeText("3")
        XCTAssertFalse(next.isEnabled, "code is too short")

        // non digits
        // not a essential test because the UI only
        // provides a numeric keyboard for this field
        field.clear(andType: "abcd")
        XCTAssertFalse(next.isEnabled, "alpha characters not allowed")
        field.clear(andType: "📭🆒🍌😶")
        XCTAssertFalse(next.isEnabled, "emojis are not allowed")
    }

    // TODO entering or typoing a wrong user code will not show
    // an error in the UI until AFTER the password has been created.
    // This is totally fine, but makes writing the test script
    // more complicated.  For the moment, this test will be disabled.
    func _test31_wrongVerificationCode() {

        let app = XCUIApplication()
        let field = app.textFields["0000"]
        let next = app.navigationBars.firstMatch.buttons["Next"]

        // TODO use a typo'd code
        let code = Int.random(from: 1000, to: 9999)
        field.tapAndClearText()
        field.typeText("\(code)")
        next.tap()
        self.wait()
    }

    func test32_validVerificationCode() {

        let app = XCUIApplication()
        let field = app.textFields["0000"]

        AdminAPI.loginAndRequestVerificationCode(for: BotUserData.email) {
            code in
            XCTAssertNotNil(code, "expected verification code is nil")
            XCTAssertNil(code?.usedAt, "verification code has already been used")
            field.tapAndClearText()
            field.typeText(code?.value ?? "")
        }
        self.wait(for: 5, label: "getting verification code")

        app.navigationBars.firstMatch.buttons["Next"].tap()
        self.wait()
    }

    // MARK:- Create account password

    func test40_invalidPassword() {

        let app = XCUIApplication()
        let passwordTextField = app.otherElements["volvoPwdTextField"]
        let confirmTextField = app.otherElements["volvoPwdConfirmTextField"]
        let next = app.navigationBars.firstMatch.buttons["Next"]

        // empty password
        XCTAssertFalse(next.isEnabled)

        // too short
        passwordTextField.tap(andType: "a")
        confirmTextField.tap(andType: "a")
        XCTAssertFalse(next.isEnabled)
        passwordTextField.tap(andType: "abcdefg")
        confirmTextField.tap(andType: "abcdefg")
        XCTAssertFalse(next.isEnabled)

        // 8+ characters but no digit
        passwordTextField.tap(andType: "abcdefgh")
        confirmTextField.tap(andType: "abcdefgh")
        XCTAssertFalse(next.isEnabled)

        // mismatched
        passwordTextField.tapAndClearText()
        passwordTextField.typeText("abcdefghi9")
        confirmTextField.tapAndClearText()
        confirmTextField.typeText("abcdefghi8")
        XCTAssertFalse(next.isEnabled)
    }

    func test41_validPassword() {

        let app = XCUIApplication()
        
        var textField = app.otherElements["volvoPwdTextField"]
        textField.tap()
        textField.typeText(BotUserData.password)

        textField = app.otherElements["volvoPwdConfirmTextField"]
        textField.tap()
        textField.typeText(BotUserData.password)

        app.navigationBars.firstMatch.buttons["Next"].tap()
        self.wait(for: 10, label: "waiting for verification code to be accepted")
    }

    // MARK:- Create account add vehicle

    func test50_validVehicleOptions() {

        let app = XCUIApplication()

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
    }

    // MARK:- Confirm account created

    func test60_confirmCreateAccountComplete() {
        let app = XCUIApplication()
        XCTAssertTrue(app.staticTexts["Your Volvo"].exists)
    }

    // MARK:- Account already exists

    func test70_launchAndCreateExistingAccount() {

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
        self.wait(for: 5, label: "waiting for server to reject existing phone number")

        // this just tests that an error is thrown, it is not checking
        // that the error text matches the offending input
        let alert = app.alerts["Error"]
        XCTAssertTrue(alert.exists)
    }

    // MARK:- Create account from launch

    func _test90_launchAndCreateAccountHappyPath() {

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
}
