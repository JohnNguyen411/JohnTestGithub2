//
//  Inspection_APITests.swift
//  voluxe-driverAPITests
//
//  Created by Christoph on 10/29/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import XCTest

// IMPORTANT!
// These tests require that the xcodebots@luxe.com user
// has at least one request assigned to them for today.
// If not, nearly all the tests will fail.

class Inspection_APITests: XCTestCase {

    static var driver: Driver?
    static var request: Request?

    func test00_loginDriver() {
        DriverAPI.login(email: "xcodebots@luxe.com", password: "luxebyvolvo7") {
            driver, error in
            XCTAssertNil(error)
            XCTAssertNotNil(driver)
            XCTAssertTrue(driver?.email == "xcodebots@luxe.com")
            Inspection_APITests.driver = driver
        }
        self.wait()
    }

    func test01_today() {
        guard let driver = Inspection_APITests.driver else { XCTFail(); return }
        DriverAPI.today(for: driver) {
            requests, error in
            XCTAssertNil(error)
            XCTAssertNotNil(requests)
            XCTAssertTrue(requests.count > 0)
            Inspection_APITests.request = requests.first
        }
        self.wait()
    }

    func test10_createVehicleInspection() {
        guard let request = Inspection_APITests.request else { XCTFail(); return }
        DriverAPI.createVehicleInspection(for: request) {
            inspection, error in
            if request.vehicleInspection != nil {
                XCTAssertNotNil(error)
                XCTAssertTrue(error == LuxeAPIError.Code.E4016)
                XCTAssertNil(inspection)
            } else {
                XCTAssertNil(error)
                XCTAssertNotNil(inspection)
            }
        }
        self.wait()
    }

    func test20_createDocumentInspection() {
        guard let request = Inspection_APITests.request else { XCTFail(); return }
        DriverAPI.createDocumentInspection(for: request) {
            inspection, error in
            XCTAssertNil(error)
            XCTAssertNotNil(inspection)
        }
        self.wait()
    }

    func test30_createLoanerInspection() {
        guard let request = Inspection_APITests.request else { XCTFail(); return }
        DriverAPI.createLoanerInspection(for: request) {
            inspection, error in
            if request.loanerInspection != nil {
                XCTAssertNotNil(error)
                XCTAssertNil(inspection)
            } else {
                let loanerRequested = request.loanerVehicleRequested ?? false
                loanerRequested ? XCTAssertNil(error) : XCTAssertNotNil(error)
                loanerRequested ? XCTAssertNotNil(inspection) : XCTAssertNil(inspection)
            }
        }
        self.wait()
    }
}
