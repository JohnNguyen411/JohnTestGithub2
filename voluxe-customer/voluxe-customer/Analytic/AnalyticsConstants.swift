//
//  AnalyticsConstants.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 4/19/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class AnalyticsConstants {
    
    // Events
    static let eventViewScreen = "view_screen"
    static let eventStateChange = "state_change"

    // Params
    static let paramScreenName = "screen_name"
    
    // Param Names
    static let paramNameState = "state"
    
    static let paramNameLandingView = "landing_view"
    static let paramNameLoadingView = "loading_view"

    static let paramNameLoginView = "login_view"
    static let paramNameResetPasswordView = "reset_password_view"
    static let paramNameUpdatePasswordView = "update_password_view"

    static let paramNameSettingsView = "settings_view"
    static let paramNameSettingsAccountView = "settings_account_view"
    static let paramNameSignupPhoneVerificationView = "signup_phone_verification_view" // Signup only
    static let paramNamePhoneVerificationView = "phone_verification_view" // Need verification after update
    static let paramNameSignupNameView = "signup_name_view"
    static let paramNameSignupEmailPhoneView = "signup_email_phone_view"
    static let paramNameSignupPasswordView = "signup_password_view"
    static let paramNameSignupAddVehicleView = "signup_add_vehicle_view" // Signup only
    static let paramNameSettingsAddVehicleView = "settings_add_vehicle_view" // From App (Settings)
    static let paramNameSettingsVehicleDetailsView = "settings_vehicle_details_view"

    static let paramNameYourVolvosView = "your_volvos_view"
    static let paramNameSchedulingInboundView = "scheduling_inbound_view" // scheduling
    static let paramNameSchedulingOutboundView = "scheduling_outbound_view"  // scheduling
    static let paramNameActiveInboundView = "active_inbound_view" // scheduled
    static let paramNameActiveOutboundView = "active_outbound_view"  // scheduled

    static let paramNameServiceNewView = "service_new_view"
    static let paramNameServiceMilestoneView = "service_milestone_view"
    static let paramNameServiceCustomView = "service_custom_view"
    static let paramNameServiceCustomNotesView = "service_custom_notes_view"
    
    static let paramNameServiceMilestoneDetailsView = "service_milestone_details_view" // only when user CAN'T schedule from here
    static let paramNameServiceMilestoneDetailsSchedulingView = "service_milestone_details_scheduling_view" // only when user CAN schedule from here
    static let paramNameServiceCustomDetailsView = "service_custom_details_view" // read only, can't schedule from here
    
    static let paramNameReservationDetailsView = "reservation_details_view"



}
