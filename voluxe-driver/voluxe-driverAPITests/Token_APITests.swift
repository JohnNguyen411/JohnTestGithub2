//
//  Token_APITests.swift
//  voluxe-driverAPITests
//
//  Created by Christoph on 11/14/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import XCTest

class Token_APITests: XCTestCase {

    func test_hostAndClientID() {

        let api = DriverAPI.api
        api.host = RestAPIHost.development
        XCTAssertTrue(api.headers["X-CLIENT-ID"] == "2SRLMO648SEEK7X66AMTLYZGSE8RSL12")

        api.host = RestAPIHost.staging
        XCTAssertTrue(api.headers["X-CLIENT-ID"] == "A8Y93ZCB8859EFIXUCEYVG2UBVB3NMUI")

        api.host = RestAPIHost.production
        XCTAssertTrue(api.headers["X-CLIENT-ID"] == "TK4KKKO9X30YKOA3VPYWBTV55W1BIY2L")
    }

    func test_token() {

        let api = DriverAPI.api
        api.token = "this is an example token"
        XCTAssertTrue(api.headers["Authorization"] == "Bearer this is an example token")

        api.token = nil
        XCTAssertTrue(api.headers["Authorization"] == nil)
    }
}
