//
//  Inspection_APITests.swift
//  voluxe-driverAPITests
//
//  Created by Christoph on 10/29/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import XCTest

class Inspection_APITests: XCTestCase {

    static var driver: Driver?
    static var request: Request?
    static var inspection: Inspection?

    func test00_loginDriver() {
        DriverAPI.login(email: "christoph@luxe.com", password: "shenoa7777") {
            driver, error in
            XCTAssertNil(error)
            XCTAssertNotNil(driver)
            XCTAssertTrue(driver?.email == "christoph@luxe.com")
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
            XCTAssertNil(error)
            XCTAssertNotNil(inspection)
        }
        self.wait()
    }

    func test20_createDocumentInspection() {
        guard let request = Inspection_APITests.request else { XCTFail(); return }
        DriverAPI.createDocumentInspection(for: request) {
            inspection, error in
            XCTAssertNil(error)
            XCTAssertNotNil(inspection)
            Inspection_APITests.inspection = inspection
        }
        self.wait()
    }

    func test21_uploadDocumentPhoto() {
        guard let request = Inspection_APITests.request else { XCTFail(); return }
        guard let inspection = Inspection_APITests.inspection else { XCTFail(); return }
        let image = UIColor.random().image()
        DriverAPI.upload(photo: image,
                         inspection: inspection,
                         request: request)
        {
            url, error in
            XCTAssertNil(error)
            XCTAssertNotNil(url)
        }
        self.wait()
    }

    func test30_createLoanerInspection() {
        guard let request = Inspection_APITests.request else { XCTFail(); return }
        DriverAPI.createLoanerInspection(for: request) {
            inspection, error in
            XCTAssertNil(error)
            XCTAssertNotNil(inspection)
            Inspection_APITests.inspection = inspection
        }
        self.wait()
    }

    func test99_resetRequest() {
        guard let request = Inspection_APITests.request else { XCTFail(); return }
        DriverAPI.reset(request) {
            error in
            XCTAssertNil(error)
        }
    }
}
