//
//  XCTest+Voluxe.swift
//  voluxe-customerUITests
//
//  Created by Christoph on 5/17/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import XCTest

extension XCTestCase {

    // Convenience function to pause a script for a bit of time.  This internally
    // uses the waitForExpectations() construct, but doesn't require littering
    // the script code with expectations.  If the expectation times out, the test
    // will fail.
    func wait(for duration: TimeInterval = 2, label description: String = "wait") {
        let expectation = self.expectation(description: description)
        let deadline = DispatchTime.now() + Double(Int64(duration * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: deadline) { expectation.fulfill() }
        self.waitForExpectations(timeout: duration + 0.1)
    }
}

extension XCTestCase {

    func loginToVehicleScreen(_ app: XCUIApplication) {

        XCTAssertTrue(app.buttons["CREATE ACCOUNT"].exists)
        app.buttons["SIGN-IN"].tap()
        self.wait()

        var textField = app.textFields["name@domain.com"]
        textField.tap()
        textField.typeText(BotUserData.email)

        textField = app.otherElements["volvoPwdTextField"]
        textField.tap()
        textField.typeText(BotUserData.password)

        app.navigationBars.firstMatch.buttons["Next"].tap()
        self.wait(for: 10, label: "logging in")

        XCTAssertTrue(app.staticTexts["Your Volvo"].exists)
    }

    func logout(_ app: XCUIApplication) {

        app.navigationBars.firstMatch.buttons["ic menu"].tap()
        app/*@START_MENU_TOKEN@*/.tables.staticTexts["Sign Out"]/*[[".otherElements[\"slideMenuController\"]",".otherElements[\"leftViewController\"].tables",".cells.staticTexts[\"Sign Out\"]",".staticTexts[\"Sign Out\"]",".tables"],[[[-1,4,2],[-1,1,2],[-1,0,1]],[[-1,4,2],[-1,1,2]],[[-1,3],[-1,2]]],[0,0]]@END_MENU_TOKEN@*/.tap()
        self.wait()

        XCTAssertTrue(app.buttons["SIGN-IN"].exists)
        XCTAssertTrue(app.buttons["CREATE ACCOUNT"].exists)
    }
}
