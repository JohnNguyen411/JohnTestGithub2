//
//  String_UnitTests.swift
//  voluxe-customerUnitTests
//
//  Created by Christoph on 8/23/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import XCTest

class String_UnitTests: XCTestCase {

    func test_email() {
        XCTAssertFalse(String.isValid(email: nil))
        self.assert(state: false, on: TestConstants.Emails.invalid) { $0.isValidEmail() }
        self.assert(state: true, on: TestConstants.Emails.valid) { $0.isValidEmail() }
    }

    func test_password() {
        XCTAssertFalse(String.isValid(password: nil))
        self.assert(state: false, on: TestConstants.Passwords.invalid) { $0.isValidPassword() }
        self.assert(state: true, on: TestConstants.Passwords.valid) { $0.isValidPassword() }
    }

    private func assert(state: Bool, on strings: [String], test: ((String) -> (Bool))) {
        for string in strings {
            XCTAssert(test(string) == state, "Expected \(string) to be \(state ? "valid" : "invalid")")
        }
    }
}
