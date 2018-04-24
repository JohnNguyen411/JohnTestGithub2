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
    static let eventViewDialog = "view_dialog"
    static let eventViewModal = "view_modal" // modal used for scheduling, etc

    static let eventClickDimissDialog = "dialog_action_dismiss"
    static let eventClickDestructiveDialog = "dialog_action_destructive"
    
    // Click events

    static let eventClickSignin = "click_signin"
    static let eventClickCreateAccount = "click_create_account"
    static let eventClickContactDriver = "click_contact_driver"
    static let eventClickUpdatePhoneNumber = "click_update_phone_number"
    static let eventClickNewService = "click_new_service"
    static let eventClickNext = "click_next"
    static let eventClickOk = "click_ok"
    static let eventClickAddNewLocation = "click_add_new_location"
    static let eventClickTimeslot = "click_timeslot"
    static let eventClickRemoveVehicle = "click_remove_vehicle"
    static let eventClickForgotPassword = "click_forgot_password"
    static let eventClickCancelInbound = "click_cancel_inbound"
    static let eventClickCancelOutbound = "click_cancel_outbound"
    static let eventClickDone = "click_done"
    static let eventClickScheduleService = "click_schedule_service"
    static let eventClickShowServiceDescription = "click_show_service_description"
    static let eventClickSelfIB = "click_self_inbound"
    static let eventClickVolvoIB = "click_volvo_inbound"
    static let eventClickSelfOB = "click_self_outbound"
    static let eventClickVolvoOB = "click_volvo_outbound"
    static let eventClickConfirmVolvoIB = "click_confirm_volvo_inbound"
    static let eventClickConfirmVolvoOB = "click_confirm_volvo_outbound"
    static let eventClickConfirmSelfIB = "click_confirm_self_inbound"
    static let eventClickConfirmSelfOB = "click_confirm_self_outbound"
    static let eventClickNavigationLeft = "click_navigation_left" // left navigation button, usually "Back"
    static let eventClickNavigationRight = "click_navigation_right" // right navigation button, usually "Next" or "Done"
    static let eventClickNavigationDone = "click_navigation_done"
    static let eventClickNavigationEdit = "click_navigation_edit"
    static let eventClickNavigationLeftMenuIcon = "click_navigation_left_menu_icon"
    static let eventClickLeftPanelMenuYourVolvos = "click_navigation_left_panel_your_volvos"
    static let eventClickLeftPanelMenuSettings = "click_navigation_left_panel_settings"
    static let eventClickLeftPanelMenuLogout = "click_navigation_left_panel_logout"
    static let eventClickLeftPanelMenuActiveBookings = "click_navigation_left_panel_active_bookings"
    static let eventClickSelectVehicle = "click_select_vehicle"
    static let eventClickServiceTypeMilestone = "click_service_type_milestone"
    static let eventClickServiceTypeCustom = "click_service_type_custom"
    static let eventClickServiceMilestone = "click_service_milestone" // pass index of select row in params
    static let eventClickSelectServiceCustom = "click_select_service_custom" // pass index of select row in params
    static let eventClickDeselectServiceCustom = "click_deselect_service_custom" // pass index of select row in params
    static let eventClickServiceCustomDrivableIndex = "click_service_custom_drivable" // pass index of select row in params
    static let eventClickSelectLocationIndex = "click_select_location_index" // pass index of select row in params
    static let eventClickSelectDealershipIndex = "click_select_dealership_index" // pass index of select row in params
    static let eventClickSelectLoanerIndex = "click_select_loaner_index" // pass index of select row in params

    // Settings click events
    static let eventClickSettingsVehicle = "click_settings_vehicle" // pass index of select row in params
    static let eventClickSettingsAddVehicle = "click_settings_add_vehicle"
    static let eventClickSettingsAccount = "click_settings_account"
    static let eventClickSettingsAccountAddAddress = "click_settings_account_add_address"
    static let eventClickSettingsAccountDeleteAddress = "click_settings_account_delete_address" // pass index of select row in params
    static let eventClickSettingsAccountEditPhone = "click_settings_account_edit_phone"
    static let eventClickSettingsAccountEditPassword = "click_settings_account_edit_password"
    
    // Success Result (ie: Address deleted, Address Added, Password changed, etc)
    static let eventSettingsAccountAddressDeleted = "settings_account_address_deleted" // pass index of select row in params
    static let eventSettingsVehicleDeleted = "settings_vehicle_deleted" // pass index of select row in params

    static let eventApiLoginSuccess = "api_login_success"
    static let eventApiLoginFail = "api_login_fail"
    static let eventApiGetMeSuccess = "api_me_success"
    static let eventApiGetMeFail = "api_me_fail"
    static let eventApiSignupSuccess = "api_signup_success"
    static let eventApiSignupFail = "api_signup_fail"
    static let eventApiVerifyPhoneSuccess = "api_verify_phone_success"
    static let eventApiVerifyPhoneFail = "api_verify_phone_fail"
    static let eventApiUpdatePhoneNumberSuccess = "api_update_phone_success"
    static let eventApiUpdatePhoneNumberFail = "api_update_phone_fail"
    static let eventApiPasswordResetCodeRequestSuccess = "api_password_reset_code_request_success"
    static let eventApiPasswordResetCodeRequestFail = "api_password_reset_code_request_fail"
    static let eventApiAddVehicleSuccess = "api_add_vehicle_success"
    static let eventApiAddVehicleFail = "api_add_vehicle_fail"
    static let eventApiGetVehiclesSuccess = "api_get_vehicles_success"
    static let eventApiGetVehiclesFail = "api_get_vehicles_fail"
    static let eventApiContactDriverSuccess = "api_contact_driver_success"
    static let eventApiContactDriverFail = "api_contact_driver_fail"
    
    static let eventApiGetBookingsSuccess = "api_get_bookings_success"
    static let eventApiGetBookingsFail = "api_get_bookings_fail"
    static let eventApiGetDealershipsSuccess = "api_get_dealerships_success"
    static let eventApiGetDealershipsFail = "api_get_dealerships_fail"
    static let eventApiGetDealershipROSuccess = "api_get_dealership_ro_success"
    static let eventApiGetDealershipROFail = "api_get_dealership_ro_fail"
    static let eventApiCreateDropoffSuccess = "api_create_dropoff_success"
    static let eventApiCreateDropoffFail = "api_create_dropoff_fail"
    static let eventApiGetDealershipTimeslotsSuccess = "api_get_dealership_timeslots_success"
    static let eventApiGetDealershipTimeslotsFail = "api_get_dealership_timeslots_fail"
    
    // Params
    static let paramScreenName = "screen_name"
    static let paramDialogName = "dialog_name"
    static let modalName = "modal_name"
    
    static let paramErrorCode = "error_code"
    static let paramStatusCode = "status_code"

    // Param Names
    static let paramNameState = "state"
    static let paramNameIndex = "index"

    static let paramNameLandingView = "landing_view"
    static let paramNameLoadingView = "loading_view"

    static let paramNameLoginView = "login_view"
    static let paramNameResetPasswordView = "reset_password_view"
    static let paramNameUpdatePasswordView = "update_password_view"

    static let paramNameSettingsView = "settings_view"
    static let paramNameSettingsAccountView = "settings_account_view"
    static let paramNameSettingsLocationModalView = "settings_location_modal_view"
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

    static let paramNameSchedulingIBDateTimeModalView = "scheduling_inbound_datetime_modal_view"
    static let paramNameSchedulingOBDateTimeModalView = "scheduling_outbound_datetime_modal_view"
    static let paramNameSchedulingIBLocationModalView = "scheduling_inbound_location_modal_view"
    static let paramNameSchedulingOBLocationModalView = "scheduling_outbound_location_modal_view"
    static let paramNameSchedulingIBDealershipModalView = "scheduling_inbound_dealership_modal_view"
    static let paramNameSchedulingOBDealershipModalView = "scheduling_outbound_dealership_modal_view"
    static let paramNameSchedulingIBLoanerModalView = "scheduling_inbound_loaner_modal_view"
    static let paramNameSchedulingOBLoanerModalView = "scheduling_outbound_loaner_modal_view"
    
    static let paramNameServiceNewView = "service_new_view"
    static let paramNameServiceMilestoneView = "service_milestone_view"
    static let paramNameServiceCustomView = "service_custom_view"
    static let paramNameServiceCustomNotesView = "service_custom_notes_view"
    
    static let paramNameServiceMilestoneDetailsView = "service_milestone_details_view" // only when user CAN'T schedule from here
    static let paramNameServiceMilestoneDetailsSchedulingView = "service_milestone_details_scheduling_view" // only when user CAN schedule from here
    static let paramNameServiceCustomDetailsView = "service_custom_details_view" // read only, can't schedule from here
    
    static let paramNameReservationDetailsView = "reservation_details_view"
    static let paramNameNeedServiceView = "need_service_view" // selected service, need to choose Self-Drop or Volvo Pickup
    static let paramNameServiceCompletedView = "service_completed_view" // service completed (after IB), need to choose Self-Pickup or Volvo Delivery
    static let paramNameServiceInProgressView = "service_in_progress_view" // service in progress at dealership
    static let paramNameServiceInRouteView = "service_in_route_view" // Driver driving to dealership to service vehicle
    static let paramNameReservationCompletedView = "reservation_completed_view" // Reservation completed

    static let paramNameDeleteAddressDialog = "delete_address_dialog"
    static let paramNameErrorDialog = "delete_error_dialog" // decided to have the same tag for every error dialog, as we are going to tag error from api on a different event anyway, and we also send the screen name.
    static let paramNameSuccessDialog = "delete_success_dialog" // decided to have the same tag for every success dialog, as we are going to tag error from api on a different event anyway, and we also send the screen name.
    static let paramNameConfirmDialog = "delete_confirm_dialog" // decided to have the same tag for every confirm dialog, as we are going to tag error from api on a different event anyway, and we also send the screen name.
    static let paramNameSelectedCustomServices = "selected_custom_services" // index of selected services


}
