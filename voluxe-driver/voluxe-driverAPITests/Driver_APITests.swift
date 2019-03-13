//
//  EditAccount_APITests.swift
//  voluxe-driverAPITests
//
//  Created by Christoph on 10/19/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import CoreLocation
import XCTest

class Driver_APITests: XCTestCase {

    static var driver: Driver?
    static var request: Request?

    func test00_loginAdmin() {
        AdminAPI.login(email: "bots@luxe.com", password: "1234qwer") {
            error in
            XCTAssertNil(error)
            XCTAssertNotNil(AdminAPI.api.token)
        }
        self.wait()
    }

    func test01_loginDriver() {
        DriverAPI.login(email: "xcodebots@luxe.com", password: "luxebyvolvo7") {
            driver, error in
            XCTAssertNil(error)
            XCTAssertNotNil(driver)
            XCTAssertTrue(driver?.email == "xcodebots@luxe.com")
            Driver_APITests.driver = driver
        }
        self.wait()
    }

    func test02_me() {
        DriverAPI.me() {
            driver, error in
            XCTAssertNil(error)
            XCTAssertNotNil(driver)
            XCTAssertTrue(Driver_APITests.driver?.id == driver?.id)
        }
        self.wait()
    }

    func test10_dealerships() {
        guard let driver = Driver_APITests.driver else { XCTFail(); return }
        DriverAPI.dealerships(for: driver) {
            dealerships, error in
            XCTAssertNil(error)
            XCTAssertFalse(dealerships.isEmpty)
        }
        self.wait()
    }

    func test20_updatePhoto() {
        guard let driver = Driver_APITests.driver else { XCTFail(); return }
        let image = UIColor.random().image()
        DriverAPI.update(photo: image, for: driver) {
            error in
            XCTAssertNil(error)
        }
        self.wait()
    }

    func test30_updateLocation() {
        guard let driver = Driver_APITests.driver else { XCTFail(); return }
        let location = CLLocationCoordinate2D.random()
        DriverAPI.update(location: location, for: driver) {
            error in
            XCTAssertNil(error)
        }
        self.wait()
    }

    func test40_registerDevice() {
        guard let driver = Driver_APITests.driver else { XCTFail(); return }
        let token = "abcdefghijklmnopqrstuvwxyz0123456789"
        DriverAPI.register(device: token, for: driver) {
            error in
            if let error = error {
                XCTAssert(error.code != .E4011)
            } else {
                XCTAssertNil(error)
            }
        }
        self.wait()
    }

    func test50_updatePhoneNumber() {
        guard let driver = Driver_APITests.driver else { XCTFail(); return }
        DriverAPI.update(phoneNumber: "+18572673282", for: driver) {
            error in
            XCTAssertNil(error)
        }
        self.wait()
    }

    func test51_requestPhoneNumberVerification() {
        guard let driver = Driver_APITests.driver else { XCTFail(); return }
        DriverAPI.requestPhoneNumberVerification(for: driver) {
            error in
            XCTAssertNil(error)
        }
        self.wait()
    }

    func test52_verifyPhoneNumberInvalidCode() {
        guard let driver = Driver_APITests.driver else { XCTFail(); return }
        let code = "1234"
        DriverAPI.verifyPhoneNumber(with: code, for: driver) {
            error in
            XCTAssertNotNil(error)
            XCTAssertTrue(error?.code == .E4012)
        }
        self.wait()
    }

    func test53_verifyPhoneNumberValidCode() {
        guard let driver = Driver_APITests.driver else { XCTFail(); return }
        AdminAPI.verificationCode(for: driver) {
            code, error in
            XCTAssertNil(error)
            XCTAssertNotNil(code)
            guard let code = code else { return }
            DriverAPI.verifyPhoneNumber(with: code, for: driver) {
                error in
                XCTAssertNil(error)
            }
        }
        self.wait()
    }

    // if the password is updated
    func test54_confirmPhoneNumberVerified() {
        DriverAPI.me() {
            driver, error in
            XCTAssertNil(error)
            XCTAssertNotNil(driver)
            XCTAssertTrue(driver!.workPhoneNumberVerified)
        }
    }

    func test60_updatePassword() {
        guard let driver = Driver_APITests.driver else { XCTFail(); return }
        DriverAPI.update(tempPassword: "luxebyvolvo7",
                         newPassword: "luxebyvolvo7",
                         for: driver)
        {
            error in
            XCTAssertNil(error)
        }
    }
}

extension CLLocationCoordinate2D {

    static func random() -> CLLocationCoordinate2D {
        let latitude = CLLocationDegrees(Double(arc4random() % 180) - 90)
        let longitude = CLLocationDegrees(Double(arc4random() % 360) - 180)
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
