//
//  Request_APITests.swift
//  voluxe-driverAPITests
//
//  Created by Christoph on 10/24/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import XCTest

class Request_APITests: XCTestCase {

    static var driver: Driver?
    static var request: Request?

    func test00_loginDriver() {
        DriverAPI.login(email: "xcodebots@luxe.com", password: "luxebyvolvo7") {
            driver, error in
            XCTAssertNil(error)
            XCTAssertNotNil(driver)
            XCTAssertTrue(driver?.email == "xcodebots@luxe.com")
            Driver_APITests.driver = driver
        }
        self.wait()
    }

    func test10_today() {
        guard let driver = Driver_APITests.driver else { XCTFail(); return }
        DriverAPI.today(for: driver) {
            requests, error in
            XCTAssertNil(error)
            XCTAssertNotNil(requests)
            XCTAssertTrue(requests.count > 0)
            Driver_APITests.request = requests.first
        }
        self.wait()
    }

    // It's too difficult to know what task to set in a test,
    // so set and wait for the expected error response.
    func test11_updatePickupTask() {
        guard let request = Driver_APITests.request else { XCTFail(); return }
        DriverAPI.update(request, task: .meetWithCustomer) {
            error in
            XCTAssertNotNil(error)
            XCTAssertTrue(error == .E4021)
        }
        self.wait()
    }

    func test12_updatePickupNotes() {
        guard let request = Driver_APITests.request else { XCTFail(); return }
        DriverAPI.update(request, notes: "notes from an API test") {
            error in
            XCTAssertNil(error)
        }
        self.wait()
    }

    func test13_contactCustomer() {
        guard let request = Driver_APITests.request else { XCTFail(); return }
        DriverAPI.contactCustomer(request) {
            textNumber, voiceNumber, error in
            XCTAssertNil(error)
            XCTAssertNotNil(textNumber ?? voiceNumber)
        }
        self.wait()
    }
}
