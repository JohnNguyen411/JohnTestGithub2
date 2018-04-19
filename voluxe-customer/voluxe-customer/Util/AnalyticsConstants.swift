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
    static let EventViewScreen = "view_screen"
    
    // Params
    static let ParamScreenName = "screen_name"
    
    // Param Names
    
    static let ParamNameLandingView = "landing_view"
    static let ParamNameLoadingView = "loading_view"

    static let ParamNameLoginView = "login_view"
    static let ParamNameResetPasswordView = "reset_password_view"
    static let ParamNameUpdatePasswordView = "update_password_view"

    static let ParamNameSettingsView = "settings_view"
    static let ParamNameSettingsAccountView = "settings_account_view"
    static let ParamNameSignupPhoneVerificationView = "signup_phone_verification_view" // Signup only
    static let ParamNamePhoneVerificationView = "phone_verification_view" // Need verification after update
    static let ParamNameSignupNameView = "signup_name_view"
    static let ParamNameSignupEmailPhoneView = "signup_email_phone_view"
    static let ParamNameSignupPasswordView = "signup_password_view"
    static let ParamNameSignupAddVehicleView = "signup_add_vehicle_view" // Signup only
    static let ParamNameSettingsAddVehicleView = "settings_add_vehicle_view" // From App (Settings)
    static let ParamNameSettingsVehicleDetailsView = "settings_vehicle_details_view"

    static let ParamNameYourVolvosView = "your_volvos_view"
    static let ParamNameSchedulingInboundView = "scheduling_inbound_view" // scheduling
    static let ParamNameSchedulingOutboundView = "scheduling_outbound_view"  // scheduling
    static let ParamNameActiveInboundView = "active_inbound_view" // scheduled
    static let ParamNameActiveOutboundView = "active_outbound_view"  // scheduled

    static let ParamNameServiceNewView = "service_new_view"
    static let ParamNameServiceMilestoneView = "service_milestone_view"
    static let ParamNameServiceCustomView = "service_custom_view"
    static let ParamNameServiceCustomNotesView = "service_custom_notes_view"
    
    static let ParamNameServiceMilestoneDetailsView = "service_milestone_details_view" // only when user CAN'T schedule from here
    static let ParamNameServiceMilestoneDetailsSchedulingView = "service_milestone_details_scheduling_view" // only when user CAN schedule from here
    static let ParamNameServiceCustomDetailsView = "service_custom_details_view" // read only, can't schedule from here
    
    static let ParamNameReservationDetailsView = "reservation_details_view"



}
