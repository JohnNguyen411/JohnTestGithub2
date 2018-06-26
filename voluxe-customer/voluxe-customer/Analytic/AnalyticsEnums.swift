//
//  AnalyticsEnums.swift
//  voluxe-customer
//
//  Created by Christoph on 6/11/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

//
// <event>_<element>_<name> <param>=<name/value>
// event_element_name
//
// click_button_signup
// view_dialog_error dialog_name=<string>
// call_api_luxe api_endpoint=<string> error_code=<string>
//
struct AnalyticsEnums {

    enum Event: String {
        case call
        case click
        case stateChange = "state_change"
        case view
    }

    enum Element: String {
        case api
        case booking
        case button
        case dialog
        case link
        case modal
        case screen
    }

    enum Name: String {

        enum API: String, CaseIterable {
            case google
            case luxe
        }

        enum Button: String, CaseIterable {
            case signIn = "signin"
            case createAccount = "createaccount"
        }

        enum Dialog: String, CaseIterable {
            case confirm
            case error
            case success
        }

        enum Modal: String, CaseIterable {
            case settingsLocation = "settings_location"
        }

        enum Screen: String, CaseIterable {
            case landing
            case loading
            case splash
        }

        // compiler seems to want this, must be related
        // to a nested enum having an associated value
        typealias RawValue = String
        case requiredCaseForRawValue
    }

    // TODO these would map to Firebase fixed params
    // TODO should enums have associated value or should the SDK specific extension do it?
    enum Param: String {
        case endpoint = "api_endpoint"
        case errorCode = "error_code"
        case errorMessage = "error_message"
        case screenName = "screen_name"
//        case dialogName = "dialog_name"
//        case modalName = "modal_name"
        case statusCode = "status_code"
    }

    typealias Params = [Param: String]
}

extension AnalyticsEnums {

    enum GoogleEndpoint: String {
        case distance
        case geocode
        case places
        case roads
    }
}

/// Base class that provides the wrapper around a particular
/// analytics SDK.  These methods are private and should not
/// be called directly.  Instead, use the extensions which
/// provide higher order funcs that easier to read and type.
class Analytics2 {

    /// Convenience method that will create a AnalyticsEnums.Params
    /// dictionary from the param and value.
    private final func track(event: AnalyticsEnums.Event,
                             element: AnalyticsEnums.Element,
                             name: AnalyticsEnums.Name.RawValue,
                             param: AnalyticsEnums.Param? = nil,
                             value: String? = nil)
    {
        var params: AnalyticsEnums.Params = [:]
        if let param = param, let value = value { params[param] = value }
        self.track(event: event, element: element, name: name, params: params)
    }

    // TODO find a way to protect this from direct calls but still
    // allow to be overridden by subclasses binding to SDKs.
    /// Override point for integration with 3rd party analytics SDKs.
    func track(event: AnalyticsEnums.Event,
               element: AnalyticsEnums.Element,
               name: AnalyticsEnums.Name.RawValue,
               params:  AnalyticsEnums.Params? = nil)
    {
        // Subclasses are encouraged to override and transform the arguments
        // into the SDK compatible versions.
    }
}

extension Analytics2 {

    // MARK:- Calls

    // TODO is this func necessary?
    // call_api_<name> api_endpoint=<string> error_code=<string>
    func trackCall(api: AnalyticsEnums.Name.API, endpoint: String? = nil, error: Errors? = nil) {
        var params: AnalyticsEnums.Params = [:]
        if let endpoint = endpoint { params[AnalyticsEnums.Param.endpoint] = endpoint }
        if let errorCode = error?.apiError?.code { params[AnalyticsEnums.Param.errorCode] = errorCode }
        if let statusCode = error?.statusCode { params[AnalyticsEnums.Param.statusCode] = "\(statusCode)" }
        self.track(event: .call, element: .api, name: api.rawValue, params: params)
    }

    func trackCallLuxe(endpoint: String, errorCode: Errors.ErrorCode? = nil, statusCode: Int? = nil) {
        var params: AnalyticsEnums.Params = [:]
        params[AnalyticsEnums.Param.endpoint] = endpoint
        if let errorCode = errorCode { params[AnalyticsEnums.Param.errorCode] = errorCode.rawValue }
        if let statusCode = statusCode { params[AnalyticsEnums.Param.statusCode] = "\(statusCode)" }
        self.track(event: .call, element: .api, name: AnalyticsEnums.Name.API.luxe.rawValue, params: params)
    }

    /// Convenience func that instruments a call to a Google API endpoint with an
    /// optional error.  Note that because Error can be an arbitrary length string,
    /// it is truncated to fixed number of characters to still be readable and reduce bytes.
    func trackCallGoogle(endpoint: AnalyticsEnums.GoogleEndpoint, error: Error? = nil) {
        var params: AnalyticsEnums.Params = [:]
        params[AnalyticsEnums.Param.endpoint] = endpoint.rawValue
        // TODO truncate to a max length
        if let error = error { params[AnalyticsEnums.Param.errorMessage] = "\(error)" }
        self.track(event: .call, element: .api, name: AnalyticsEnums.Name.API.google.rawValue, params: params)
    }

    // MARK:- Clicks

    // click_button_<name> screen_name=<string>
    func trackClick(button: AnalyticsEnums.Name.Button, on screen: AnalyticsEnums.Name.Screen? = nil) {
        self.track(event: .click, element: .button, name: button.rawValue, param: .screenName, value: screen?.rawValue)
    }

    // TODO is this needed?
    // click_link_<name> screen_name=<string>
//    func trackClick(link: String, on screen: AnalyticsEnums.Screen? = nil) {
//        self.track(event: .click, element: .link, name: , param: .screenName, value: screen?.rawValue)
//    }

    // MARK:- Changes

    // TODO why not just sending in the booking itself?
    // state_change_booking_<name>
    func trackStateChangeBooking(state: String) {
        self.track(event: .stateChange, element: .booking, name: state)
    }

    // MARK:- Views

    // view_dialog_<name>
    func trackView(dialog: AnalyticsEnums.Name.Dialog) {
        self.track(event: .view, element: .dialog, name: dialog.rawValue)
    }

    // view_modal_<name>
    func trackView(modal: AnalyticsEnums.Name.Modal) {
        self.track(event: .view, element: .modal, name: modal.rawValue)
    }

    // view_screen_<name>
    func trackView(screen: AnalyticsEnums.Name.Screen) {
        self.track(event: .view, element: .screen, name: screen.rawValue)
    }
}
