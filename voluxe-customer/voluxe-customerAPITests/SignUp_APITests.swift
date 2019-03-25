//
//  voluxe_customerAPITests.swift
//  voluxe-customerAPITests
//
//  Created by Christoph on 5/24/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import XCTest

class SignUp_APITests: XCTestCase {

    override func setUp() {
        self.continueAfterFailure = false
    }

    // MARK:- Invalid inputs for /v1/customers/signup

    func test00_signUp_invalidEmail() {

        for email in TestConstants.Emails.invalid {
            self.signUp(email: email,
                        phone: BotUserData.phone,
                        firstName: BotUserData.firstName,
                        lastName: BotUserData.lastName,
                        language: BotUserData.language)
        }
    }

    func test01_signUp_invalidPhone() {

        for phone in TestConstants.Phones.invalid {
            self.signUp(email: BotUserData.email,
                        phone: phone,
                        firstName: BotUserData.firstName,
                        lastName: BotUserData.lastName,
                        language: BotUserData.language)
        }
    }

    func test02_signUp_invalidFirstNames() {

        for name in TestConstants.Names.invalid {
            self.signUp(email: BotUserData.email,
                        phone: BotUserData.phone,
                        firstName: name,
                        lastName: BotUserData.lastName,
                        language: BotUserData.language)
        }
    }

    func test03_signUp_invalidLastNames() {

        for name in TestConstants.Names.invalid {
            self.signUp(email: BotUserData.email,
                        phone: BotUserData.phone,
                        firstName: BotUserData.firstName,
                        lastName: name,
                        language: BotUserData.language)
        }
    }

    func test04_signUp_invalidLanguage() {

        for language in TestConstants.Languages.invalid {
            self.signUp(email: BotUserData.email,
                        phone: BotUserData.phone,
                        firstName: BotUserData.firstName,
                        lastName: BotUserData.lastName,
                        language: language)
        }
    }

    /// Helper function to handle responses from the sign up request.
    /// This uses an expectation serialize (prevent overlapping) the
    /// requests and will fail the test if the request succeeds or
    /// if the expected response error code is not seen.
    ///
    /// Note that a success response might not be an indication of a
    /// an endpoint failure, but that the input values are not in sync
    /// with the endpoint's documentation.  Cue religious war on who
    /// does input validation: client or server.
    private func signUp(email: String, phone: String, firstName: String, lastName: String, language: String) {
        
        let expectation = self.expectation(description: "waiting for sign up response")
        
        let inputs = "\(email) \(phone) \(firstName) \(lastName) \(language)"
        print("TESTING: \(inputs)")
        
        VolvoValetCustomerAPI.signup(email: email,
                           phoneNumber: phone,
                           firstName: firstName,
                           lastName: lastName,
                           languageCode: language, completion: { customer, error in
                            
                            if let error = error {
                                expectation.fulfill()
                                XCTAssertNotNil(error, "Expected an error, got a nil error")
                                guard let code = error.code else { return }
                                if code == .E4011 { print("FAILED: Previous test allowed an account to be created") }
                                XCTAssertTrue(code == .E4002, "Expected code=E4002, got \(code) \(error.message ?? "None")")
                            } else {
                                expectation.fulfill()
                                XCTFail("Was allowed to create a customer with inputs:\n\(inputs)")
                            }
        })
        
        self.wait(for: [expectation], timeout: 10)
    }
//
//    // MARK:- Invalid inputs for /v1/customers/signup/confirm
//
//    // email, phone, password, verification code
//    func _test10_confirmSignUp() {
//
//        // make successful sign up request
//        // get token from admin API
//        // attempt to verify with invalid inputs
//    }
//
//    // customer ID
//    func _test20_requestVerificationCode() {
//
//    }
//
//    // customer ID, verification code
//    func _test30_verifyPhoneNumber() {
//
//    }
}
