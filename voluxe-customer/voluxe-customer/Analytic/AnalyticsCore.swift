//
//  AnalyticsCore.swift
//  voluxe-customer
//
//  Created by Christoph on 6/27/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

/// Base class that provides the wrapper around a particular
/// analytics SDK.  These methods are private and should not
/// be called directly.  Instead, use the extensions which
/// provide higher order funcs that easier to read and type.
class AnalyticsCore {

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

    /// Override point for integration with 3rd party analytics SDKs.
    /// This should not be called directly.
    func track(event: AnalyticsEnums.Event,
               element: AnalyticsEnums.Element,
               name: AnalyticsEnums.Name.RawValue,
               params:  AnalyticsEnums.Params? = nil)
    {
        // Subclasses are encouraged to override and transform the arguments
        // into the SDK compatible versions.
    }
}

extension AnalyticsCore {

    // MARK:- Calls

    func trackCall(api: AnalyticsEnums.Name.API, endpoint: String? = nil, error: Errors? = nil) {
        var params: AnalyticsEnums.Params = [:]
        if let endpoint = endpoint { params[.endpoint] = endpoint }
        if let errorCode = error?.apiError?.code { params[.errorCode] = errorCode }
        if let statusCode = error?.statusCode { params[.statusCode] = "\(statusCode)" }
        self.track(event: .call, element: .api, name: api.rawValue, params: params)
    }

    func trackCallLuxe(endpoint: String,
                       errorCode: Errors.ErrorCode? = nil,
                       statusCode: Int? = nil,
                       requestID: String? = nil)
    {
        var params: AnalyticsEnums.Params = [:]
        params[.endpoint] = endpoint
        if let errorCode = errorCode { params[.errorCode] = errorCode.rawValue }
        if let statusCode = statusCode { params[.statusCode] = "\(statusCode)" }
        if let requestID = requestID { params[.requestID] = "\(requestID)" }
        self.track(event: .call, element: .api, name: AnalyticsEnums.Name.API.luxe.rawValue, params: params)
    }

    /// Convenience func that instruments a call to a Google API endpoint with an
    /// optional error.  Note that because Error can be an arbitrary length string,
    /// it is truncated to 40 characters to save bytes and safety.
    func trackCallGoogle(endpoint: AnalyticsEnums.GoogleEndpoint, error: Error? = nil) {
        var params: AnalyticsEnums.Params = [:]
        params[.endpoint] = endpoint.rawValue
        if let error = error { params[.errorMessage] = String("\(error)".prefix(40)) }
        self.track(event: .call, element: .api, name: AnalyticsEnums.Name.API.google.rawValue, params: params)
    }

    // MARK:- Clicks

    func trackClick(button: AnalyticsEnums.Name.Button,
                    screen: AnalyticsEnums.Name.Screen? = nil,
                    selected: Bool? = nil)
    {
        var params: AnalyticsEnums.Params = [:]
        if let screen = screen { params[.screenName] = screen.rawValue }
        if let selected = selected { params[.selected] = "\(selected)" }
        self.track(event: .click, element: .button, name: button.rawValue, params: params)
    }

    func trackClick(navigation: AnalyticsEnums.Name.Navigation,
                    screen: AnalyticsEnums.Name.Screen? = nil)
    {
        var params: AnalyticsEnums.Params = [:]
        if let screen = screen { params[.screenName] = screen.rawValue }
        self.track(event: .click, element: .navigation, name: navigation.rawValue, params: params)
    }

    // MARK:- Changes

    func trackChangeBooking(state: String, id: Int? = nil) {
        var params: AnalyticsEnums.Params = [:]
        params[.bookingState] = state
        if let id = id { params[.bookingID] = "\(id)" }
        self.track(event: .change, element: .booking, name: AnalyticsEnums.Name.Booking.state.rawValue, params: params)
    }

    func trackChangePermission(permission: AnalyticsEnums.Name.Permission, granted: Bool, screen: AnalyticsEnums.Name.Screen? = nil) {
        var params: AnalyticsEnums.Params = [:]
        if let screen = screen { params[.screenName] = screen.rawValue }
        params[.granted] = granted ? 1 : 0
        self.track(event: .change, element: .permission, name: permission.rawValue, params: params)
    }

    // MARK:- Views

    func trackView(app: AnalyticsEnums.Name.App, screen: AnalyticsEnums.Name.Screen? = nil) {
        var params: AnalyticsEnums.Params = [:]
        if let screen = screen { params[.screenName] = screen.rawValue }
        self.track(event: .view, element: .app, name: app.rawValue, params: params)
    }

    func trackView(screen: AnalyticsEnums.Name.Screen, from: AnalyticsEnums.Name.Screen? = nil) {
        var params: AnalyticsEnums.Params = [:]
        if let from = from { params[.screenName] = from.rawValue }
        self.track(event: .view, element: .screen, name: screen.rawValue, params: params)
    }
}
