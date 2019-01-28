//
//  voluxe_driverAPITests.swift
//  voluxe-driverAPITests
//
//  Created by Christoph on 10/16/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import XCTest

class Login_APITests: XCTestCase {

    func test00_loginInvalid() {

        DriverAPI.login(email: "driverapitest@luxe.com", password: "password") {
            user, error in
            XCTAssertNil(user)
            XCTAssertNotNil(error)
            XCTAssertTrue(error?.code == .E2005)
        }

        self.wait()
    }

    func test01_logoutNoToken() {

        DriverAPI.logout() {
            error in
            XCTAssertNotNil(error)
            XCTAssertTrue(error?.code == .E2001)
        }

        self.wait()
    }

    func test10_loginValid() {

        DriverAPI.login(email: "christoph@luxe.com", password: "shenoa7777") {
            user, error in
            XCTAssertNil(error)
            XCTAssertNotNil(user)
            XCTAssertTrue(user?.email == "christoph@luxe.com")
        }

        self.wait()
    }

    func test11_logoutWithToken() {

        DriverAPI.logout() {
            error in
            XCTAssertNil(error)
        }

        self.wait()
    }
}
