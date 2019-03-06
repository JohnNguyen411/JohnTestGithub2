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
        continueAfterFailure = true
    }

    // MARK:- Launch
 
    func test00_launchAndTapCreateAccount() {

        let app = XCUIApplication()
        app.launchArguments = ["logoutOnLaunch", "testMode"]
        app.launch()
        self.wait(for: 5, label: "waiting for app to finish launching")

        XCTAssertTrue(app.buttons[String.localized(.viewIntroFooterSignin).uppercased()].exists)
        app.buttons[String.localized(.viewIntroFooterSignup).uppercased()].tap()
        self.wait()

        XCTAssertTrue(app.staticTexts["welcomeLabel"].exists)
    }

    // MARK:- Create account names

    func test10_invalidNames() {

        let app = XCUIApplication()

        let firstNameTextfield = app.textFields[String.localized(.viewEditTextInfoHintFirstName)]
        let lastNameTextfield = app.textFields[String.localized(.viewEditTextInfoHintLastName)]
        let next = app.navigationBars.firstMatch.buttons[String.localized(.next)]

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

        var textField = app.textFields[String.localized(.viewEditTextInfoHintFirstName)]
        textField.tapAndClearText()
        textField.typeText(BotUserData.firstName)

        textField = app.textFields[String.localized(.viewEditTextInfoHintLastName)]
        textField.tapAndClearText()
        textField.typeText(BotUserData.lastName)

        let next = app.navigationBars.firstMatch.buttons[String.localized(.next)]
        XCTAssertTrue(next.isEnabled)
        next.tap()
        self.wait()
    }

    // MARK:- Create account contact email and phone number

    func test20_invalidEmailAndPhone() {

        let app = XCUIApplication()

        let tosCheckbox = app.otherElements["tosCheckbox"]
        let emailTextfield = app.textFields[String.localized(.viewEditTextInfoHintEmail)]
        let phoneTextfield = app.textFields[String.localized(.viewEditTextInfoHintPhoneNumber)]
        let next = app.navigationBars.firstMatch.buttons[String.localized(.next)]

        // next button is disabled by default
        XCTAssertFalse(next.isEnabled)
        
        // check the tosCheckbox to make sure next button not showing with invalid data
        tosCheckbox.tap()
        XCTAssertTrue(tosCheckbox.isEnabled)

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

        // uncheck the tosCheckbox
        tosCheckbox.tap()
        // tap the next button
        next.tap()
        // make sure we didn't progress as the checkbox isn't checked
        self.wait()
        
        // check the tosCheckbox
        tosCheckbox.tap()
    }

    func test21_validEmailAndPhone() {

        let app = XCUIApplication()

        var textField = app.textFields[String.localized(.viewEditTextInfoHintEmail)]
        textField.tapAndClearText()
        textField.typeText(BotUserData.email)

        textField = app.textFields[String.localized(.viewEditTextInfoHintPhoneNumber)]
        textField.tapAndClearText()
        textField.typeText(BotUserData.phone)
        
        let next = app.navigationBars.firstMatch.buttons[String.localized(.next)]
        XCTAssertTrue(next.isEnabled)
        next.tap()
        self.wait()
    }
    
    // MARK:- Verify phone number

    func test30_invalidVerificationCode() {

        let app = XCUIApplication()
        let field = app.textFields["0000"]
        let next = app.navigationBars.firstMatch.buttons[String.localized(.next)]

        // too short 0 to 3 characters
        XCTAssertFalse(next.isEnabled, "not code has been entered")
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
        let next = app.navigationBars.firstMatch.buttons[String.localized(.next)]

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
            code, error in
            XCTAssertNotNil(code, "expected verification code is nil")
            XCTAssertNil(code?.used_at, "verification code has already been used")
            field.tapAndClearText()
            field.typeText(code?.value ?? "")
        }
        self.wait(for: 10, label: "getting verification code")

        app.navigationBars.firstMatch.buttons[String.localized(.next)].tap()
        self.wait()
    }

    // MARK:- Create account password

    func test40_invalidPassword() {

        let app = XCUIApplication()
        let passwordTextField = app.otherElements["volvoPwdTextField"]
        let confirmTextField = app.otherElements["volvoPwdConfirmTextField"]
        let next = app.navigationBars.firstMatch.buttons[String.localized(.next)]

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
        // this will allow the Next button to be enabled
        // but will change the UI to show an error state
        passwordTextField.tap(andType: "abcdefgh")
        confirmTextField.tap(andType: "abcdefgh")
        XCTAssertTrue(next.isEnabled)
        next.tap()
        XCTAssertTrue(app.staticTexts[String.localized(.viewSignupPasswordRequireNumber).uppercased()].exists)

        // mismatched
        passwordTextField.clear(andType: "abcdefghi9")
        confirmTextField.clear(andType: "abcdefghi8")
        XCTAssertTrue(next.isEnabled)
        next.tap()
        XCTAssertTrue(app.staticTexts[String.localized(.errorPasswordNotMatch).uppercased()].exists)
    }

    func test41_validPassword() {

        let app = XCUIApplication()
        
        var textField = app.otherElements["volvoPwdTextField"]
        textField.tap()
        textField.typeText(BotUserData.password)

        textField = app.otherElements["volvoPwdConfirmTextField"]
        textField.tap()
        textField.typeText(BotUserData.password)

        app.navigationBars.firstMatch.buttons[String.localized(.next)].tap()
        self.wait(for: 10, label: "waiting for verification code to be accepted")
    }

    // MARK:- Create account add vehicle

    func test50_invalidVehicleOptions() {

        let app = XCUIApplication()
        let yearTextfield = app.textFields[String.localized(.viewVehicleAddYearHint)]
        let modelTextfield = app.textFields[String.localized(.viewVehicleAddModelHint)]
        let colorTextfield = app.textFields[String.localized(.viewVehicleAddColorHint)]

        // should be disabled without any input
        let done = app.navigationBars.firstMatch.buttons[String.localized(.next)]
        XCTAssertFalse(done.isEnabled)

        // year only allows 4 digits
        modelTextfield.clear(andType: String.localized(.viewVehicleAddModelHint))
        colorTextfield.clear(andType: String.localized(.viewVehicleAddColorHint))
        yearTextfield.clear(andType: "1")
        XCTAssertFalse(done.isEnabled)
        yearTextfield.clear(andType: "12345")
        XCTAssertFalse(done.isEnabled)
        yearTextfield.clear(andType: "abcd")
        XCTAssertFalse(done.isEnabled)
        yearTextfield.clear(andType: "📭🆒🍌😶")
        XCTAssertFalse(done.isEnabled)

        // model allows alphanumeric only
        yearTextfield.clear(andType: String.localized(.viewVehicleAddYearHint))
        colorTextfield.clear(andType: "Black")
        modelTextfield.clear(andType: "📭🆒🍌😶")
        XCTAssertFalse(done.isEnabled)
        modelTextfield.clear(andType: "abcdefgh777")
        XCTAssertFalse(done.isEnabled)

        // color only allows alpha
        yearTextfield.clear(andType: String.localized(.viewVehicleAddYearHint))
        modelTextfield.clear(andType: String.localized(.viewVehicleAddModelHint))
        colorTextfield.clear(andType: "random")
        XCTAssertFalse(done.isEnabled)
        colorTextfield.clear(andType: "123456")
        XCTAssertFalse(done.isEnabled)
        colorTextfield.clear(andType: "📭🆒🍌😶")
        XCTAssertFalse(done.isEnabled)

        // clear all fields
        yearTextfield.tapAndClearText()
        modelTextfield.tapAndClearText()
        colorTextfield.tapAndClearText()
    }

    func test51_validVehicleOptions() {

        let app = XCUIApplication()
        let done = app.toolbars["Toolbar"].buttons[String.localized(.done)]

        app.textFields[String.localized(.viewVehicleAddYearHint)].tap()
        done.tap()
        self.wait()

        app.textFields[String.localized(.viewVehicleAddModelHint)].tap()
        done.tap()
        self.wait()

        app.textFields[String.localized(.viewVehicleAddColorHint)].tap()
        done.tap()
        self.wait()

        app.navigationBars.firstMatch.buttons[String.localized(.next)].tap()
        self.wait(for: 10, label: "waiting for vehicle to be created")
    }

    // MARK:- Confirm account created

    func test60_confirmCreateAccountComplete() {

        let app = XCUIApplication()

        XCTAssertTrue(app.otherElements[String.localized(.viewScheduleService)].exists)
    }

    // MARK:- Account already exists

    func test70_launchAndCreateExistingAccount() {

        let app = XCUIApplication()
        app.launchArguments = ["logoutOnLaunch", "testMode"]
        app.launch()
        self.wait()

        XCTAssertTrue(app.buttons[String.localized(.viewIntroFooterSignin).uppercased()].exists)
        app.buttons[String.localized(.viewIntroFooterSignup).uppercased()].tap()
        self.wait()

        var textField = app.textFields[String.localized(.viewEditTextInfoHintFirstName)]
        textField.tap()
        textField.typeText(BotUserData.firstName)

        textField = app.textFields[String.localized(.viewEditTextInfoHintLastName)]
        textField.tap()
        textField.typeText(BotUserData.lastName)

        app.navigationBars.firstMatch.buttons[String.localized(.next)].tap()
        self.wait()

        textField = app.textFields[String.localized(.viewEditTextInfoHintEmail)]
        textField.tap()
        textField.typeText(BotUserData.email)

        textField = app.textFields[String.localized(.viewEditTextInfoHintPhoneNumber)]
        textField.tap()
        textField.typeText(BotUserData.phone)

        app.navigationBars.firstMatch.buttons[String.localized(.next)].tap()
        self.wait(for: 5, label: "waiting for server to reject existing phone number")

        // this just tests that an error is thrown, it is not checking
        // that the error text matches the offending input
        let alert = app.alerts[String.localized(.error)]
        XCTAssertTrue(alert.exists)
    }
}
