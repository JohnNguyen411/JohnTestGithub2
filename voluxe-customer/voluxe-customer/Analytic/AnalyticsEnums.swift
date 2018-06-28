//
//  AnalyticsEnums.swift
//  voluxe-customer
//
//  Created by Christoph on 6/11/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

// Event format
// <action>_<element>_<name> <param>=<name/value>
// action_element_name
//
// click_button_signup
// view_dialog_error dialog_name=<string>
// call_api_luxe api_endpoint=<string> error_code=<string>
//
struct AnalyticsEnums {

    enum Event: String {
        case call
        case click
        case change
        case view
    }

    enum Element: String {
        case api
        case booking
        case button
        case permission
        case screen
    }

    enum Name: String {

        enum API: String, CaseIterable {
            case google
            case luxe
        }

        enum Booking: String, CaseIterable {
            case state
        }

        enum Button: String, CaseIterable {
            case createAccount
            case requestLocation
            case requestNotifications
            case signIn
            case vehicleEngine
            case vehicleExterior
            case vehicleInterior
            case vehicleUnknown
        }

        enum Permission: String, CaseIterable {
            case location
            case notification
        }

        enum Screen: String, CaseIterable {
            case account
            case activeInbound
            case activeOutbound
            case allowLocation
            case allowNotifications
            case bookingFeedback
            case bookings   // Pickup & Delivery, my volvos, reservations?
            case confirm
            case error
            case landing
            case loading
            case location
            case login
            case needService
            case passwordReset
            case phoneUpdate
            case phoneVerification
            case reservations
            case reservationCompleted
            case reservationDetail
            case scheduleInbound
            case scheduleInboundDateTime
            case scheduleInboundDealership
            case scheduleInboundLoaner
            case scheduleInboundLocation
            case scheduleOutbound
            case scheduleOutboundDateTime
            case scheduleOutboundLocation
            case serviceCompleted
            case serviceCustom
            case serviceCustomDetail
            case serviceCustomNotes
            case serviceEnRoute
            case serviceInProgress
            case serviceMilestone
            case serviceMilestoneDetail
            case serviceMilestoneDateTime
            case serviceNew
            case settings
            case signupEmail
            case signupName
            case signupPassword
            case signupPhone
            case signupPhoneVerification
            case splash
            case success
            case vehicleAdd
            case vehicleDelete
            case vehicleDetail
        }

        // compiler seems to want this, must be related
        // to a nested enum having an associated value
        typealias RawValue = String
        case requiredCaseForRawValue
    }

    enum Param: String, CaseIterable {
        case bookingState = "booking_state"
        case endpoint = "api_endpoint"
        case errorCode = "error_code"
        case errorMessage = "error_message"
        case granted
        case screenName = "screen_name"
        case selected
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
