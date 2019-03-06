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
        case log
        case slide
        case view
    }

    enum Element: String {
        case api
        case app
        case booking
        case button
        case navigation
        case permission
        case screen
        case task
    }

    enum Name: String {

        enum API: String, CaseIterable {
            case google
            case luxe
        }

        enum App: String, CaseIterable {
            case deeplinkSignup
            case deeplinkSuccess
        }

        enum Booking: String, CaseIterable {
            case state
        }
        
        enum Request: String, CaseIterable {
            case task
        }

        enum Button: String, CaseIterable {
            
            // driver
            case leftPanelProfilePhoto
            case leftPanelChangePhone
            case leftPanelChangePassword
            case leftPanelCallDealership
            case leftPanelWaze
            case leftPanelGoogleMaps
            case leftPanelAppleMaps
            case capturePhoto
            case getRide
            case textCustomer
            case callCustomer
            case requestCurrent
            case requestUpcoming
            case flashOn
            case flashOff
            
            case addNewLocation
            case callDealership
            case callHelp
            case emailHelp
            case cancel
            case changeDropoff
            case contactDriver
            case createAccount
            case destructiveDialog
            case dismissDialog
            case done
            case forgotPassword
            case getDirections
            case leftPanelBookings
            case leftPanelSettings
            case leftPanelHelp
            case leftPanelLogout
            case inboundCancel
            case inboundSelf
            case inboundSelfConfirm
            case inboundVolvo
            case inboundVolvoConfirm
            case next
            case newService
            case ok
            case okDialog
            case outboundCancel
            case outboundSelf
            case outboundSelfConfirm
            case outboundVolvo
            case outboundVolvoConfirm
            case privacyPolicy
            case removeVehicle
            case requestLocation
            case requestNotifications
            case retry
            case scheduleDelivery
            case scheduleService
            case selectDealership
            case selectLoaner
            case selectLocation
            case selectVehicle
            case serviceCustom
            case serviceCustomDrivable
            case serviceMilestone
            case settingsVehicle
            case settingsAddVehicle
            case settingsAccount
            case settingsDeleteAddress
            case settingsEditEmail
            case settingsEditName
            case settingsEditPassword
            case settingsEditPhone
            case showDriver
            case showService
            case signIn
            case termsOfService
            case termsOfServiceCheckbox
            case timeslot
            case updatePhone
            case vehicleEngine
            case vehicleExterior
            case vehicleInterior
            case vehicleUnknown
            case viewDealershipLocation
        }

        enum Log: String, CaseIterable {
            case info
            case fatal
            case unexpected
        }

        enum Navigation: String, CaseIterable {
            case back
            case close
            case done
            case edit
            case menu
            case next
            case skip
        }

        enum Permission: String, CaseIterable {
            case location
            case notification
        }

        enum Screen: String, CaseIterable {
            case addPhone // driver
            case account
            case bookingCompleted
            case bookingDetail
            case bookingFeedback
            case changePhone // driver
            case confirm
            case confirmProfilePhoto // driver
            case deliveryReviewService // driver
            case deliveryRetrieveCustVehicle // driver
            case deliveryDriveToCustomer // driver
            case deliveryMeetCustomer // driver
            case deliveryPhotoCustomerVehicle // driver
            case deliveryReceiveLoaner // driver
            case deliveryPhotoLoaner // driver
            case deliveryExchangeKey // driver
            case deliveryReturnToDealership // driver
            case deliveryGetToDealership // driver
            case deliveryLoanerMileage // driver
            case deliveryLoanerMileageEmpty // driver
            case deliveryLoanerMileageTooLess // driver
            case deliveryLoanerMileageTooHigh // driver
            case deliveryTooFarFromCustomer // driver
            case deliveryTooFarFromDealership // driver
            case deliveryAlreadyStartedDriving // driver
            case deliveryUnknown // driver
            case dropoffActive
            case dropoffNew
            case dropoffDateTime
            case dropoffLocation
            case dropoffSelfActive
            case emailUpdate
            case error
            case help
            case helpList
            case helpDetail
            case forgotPassword
            case landing
            case loading
            case location
            case locationPermissionDenied
            case login
            case nameUpdate
            case needService
            case pickupActive
            case pickupAlreadyStartedDriving // driver
            case pickupDateTime
            case pickupDealership
            case pickupDriveToCustomer // driver
            case pickupExchangeKey // driver
            case pickupGetPaperwork // driver
            case pickupGetToCustomer // driver
            case pickupLoaner
            case pickupLoanerMileage // driver
            case pickupLoanerMileageEmpty // driver
            case pickupLoanerMileageTooLess // driver
            case pickupLoanerMileageTooHigh // driver
            case pickupLocation
            case pickupMeetCustomer // driver
            case pickupNew
            case pickupPhotoCustomerVehicle // driver
            case pickupPhotoDocuments // driver
            case pickupPhotoLoaner // driver
            case pickupReviewService // driver
            case pickupRetrieveLoaner // driver
            case pickupReturnToDealership // driver
            case pickupSelfActive
            case pickupTooFarFromCustomer // driver
            case pickupTooFarFromDealership // driver
            case pickupUnknown // driver
            case pickupVehicleNotes // driver
            case passwordReset
            case phoneUpdate
            case phoneVerification
            case privacyPolicy
            case profilePhoto // driver
            case requestLocation
            case requestNotifications
            case scheduleToday // driver
            case selfOBModal
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
            case signupComplete
            case signupName
            case signupPassword
            case signupPhone
            case signupPhoneVerification
            case splash
            case termsOfService
            case vehicles
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
        case bookingID = "booking_id"
        case bookingState = "booking_state"
        case endpoint = "api_endpoint"
        case errorCode = "error_code"
        case errorMessage = "error_message"
        case granted
        case message
        case requestID = "request_id"
        case requestTask = "request_task"
        case screenName = "screen_name"
        case selected
        case statusCode = "status_code"
    }

    typealias Params = [Param: Any]
}

extension AnalyticsEnums {

    enum GoogleEndpoint: String {
        case distance
        case geocode
        case places
        case roads
    }
}
