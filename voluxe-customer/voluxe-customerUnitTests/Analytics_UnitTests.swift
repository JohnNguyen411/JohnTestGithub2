//
//  voluxe_customerTests.swift
//  voluxe-customerTests
//
//  Created by Giroux, Johan on 10/24/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Alamofire
import XCTest

class Analytics_UnitTests: XCTestCase {

    /// Ensures that the Firebase event name mangler is working correctly.
    /// This is not an exhaustive test, it should check only some of the
    /// combinations of event, element and name.
    func test_FirebaseEventNames() {

        let analytics = FBAnalytics()

        analytics.trackOutputClosure = {
            name, params in
            XCTAssertTrue(name == "call_api_luxe")
        }
        analytics.trackCall(api: .luxe)

        analytics.trackOutputClosure = {
            name, params in
            XCTAssertTrue(name == "call_api_gmaps")
        }
        analytics.trackCall(api: .gmaps)

        analytics.trackOutputClosure = {
            name, params in
            XCTAssertTrue(name == "click_button_signin")
        }
        analytics.trackClick(button: .signIn)

        // TODO need state change test

        analytics.trackOutputClosure = {
            name, params in
            XCTAssertTrue(name == "view_dialog_confirm")
        }
        analytics.trackView(dialog: .confirm)

        analytics.trackOutputClosure = {
            name, params in
            XCTAssertTrue(name == "view_modal_settings_location")
        }
        analytics.trackView(modal: .settingsLocation)

        analytics.trackOutputClosure = {
            name, params in
            XCTAssertTrue(name == "view_screen_splash")
        }
        analytics.trackView(screen: .splash)
    }

    /// Ensures that the dictionary transform does not break the dictionary.
    /// Because the dictionaries are typed there is not much to test other
    /// than that the key and value was transformed and exists in the resulting
    /// Firebase dictionary.
    func test_FirebaseParams() {

        let analytics = FBAnalytics()

        // endpoint param
        analytics.trackOutputClosure = {
            event, params in
            XCTAssertTrue(event == "call_api_luxe")
            XCTAssertNotNil(params?.keys.first)
            XCTAssertTrue(params?.keys.first == AnalyticsEnums.Param.endpoint.rawValue)
            XCTAssertTrue((params?.values.first as? String?) == "some endpoint")
        }
        analytics.trackCall(api: .luxe, endpoint: "some endpoint")

        // error and status code params
        // checks that all 3 params are included and are strings
        analytics.trackOutputClosure = {
            event, params in
            XCTAssertTrue(params?.count == 3)
            XCTAssertTrue((params?[AnalyticsEnums.Param.errorCode.rawValue] as? String) == Errors.ErrorCode.E2001.rawValue)
            XCTAssertTrue((params?[AnalyticsEnums.Param.statusCode.rawValue] as? String) == "200")
        }
        let responseError = ResponseError.with(errorCode: .E2001)
        let errors = Errors.with(responseError: responseError)
        analytics.trackCall(api: .luxe, endpoint: "some endpoint", error: errors)
    }
}

extension Errors {

    /// Creates an Errors with a default status and the specified response error.
    static func with(responseError: ResponseError) -> Errors {
        let result = Result { "" as Any }
        let dataResponse = DataResponse(request: nil, response: nil, data: nil, result: result)
        let errors = Errors(dataResponse: dataResponse, apiError: responseError)
        return errors
    }
}

extension ResponseError {

    /// Creates a ResponseError with the specified API error code.
    static func with(errorCode: Errors.ErrorCode) -> ResponseError {
        let response = ResponseError()
        response.error = true
        response.code = errorCode.rawValue
        return response
    }
}
