//
//  Constants.swift
//  hse
//
//  Created by Kimmo Lahdenkangas on 07/03/16.
//  Copyright © 2016 Volvo. All rights reserved.
//

import Foundation

class Constants {
    
    static let ServerConfigPathKey = "/config"
    static let ServerUrlKey = "com.volvocars.hse.serverUrl"
    static let AppDynamicsUUIDKey = "com.volvocars.hse.appDynamicsUUID"
    static let LoginPathKey = "loginUrl"
    static let ValidationUrlKey = "validationUrl"
    static let UserDefaultsInitializedKey = "com.volvocars.hse.defaultsInitilized"
    static let HasValidSessionKey = "com.volvocars.hse.hasValidSession"
    static let AccessTokenKey = "com.volvocars.hse.accessToken"
    static let RefreshTokenKey = "com.volvocars.hse.refreshToken"
    static let fsapiContextAndVersion = "/fsapi/v1"
    
    static let UserNameKey = "com.volvocars.hse.userName"
    static let UserPhoneKey = "com.volvocars.hse.userPhone"
    
    static let LoginUrl = "/openid_connect_login"
    static let ValidationUrl = "/token/validate-refresh"
    
    static let UserRegisteredForPushNotificationsKey = "com.volvocars.hse.pushToken"
    static let NotFirstUseKey = "com.volvocars.hse.firstUse"
    
    static let AnsweredNotificationRequest = "com.volvocars.hse.askedForPushPermissions"
    static let AnsweredLocationRequest = "com.volvocars.hse.askedForLocationPermissions"
    static let AnsweredPermissionRequests = "com.volvocars.hse.answeredPermissionRequests"
    
    static let PushType = "notificationType"
    static let PushTypeServiceUpdate = "serviceUpdate"
    static let PushDataField = "notificationData"
    static let NotificationTypeServiceComplete = "service-complete"
    
    static let NotFirstLogin = "com.volvocars.hse.firstLogin"
    static let AcceptedTermsAndConditions = "com.volvocars.hse.hasacceptedtermsandconditions"
    static let ShouldShowDemoQuotes = "com.volvocars.hse.shouldshowdemoquotes"
    
    static let VehicleImageBaseUrl = "http://concierge-vehicle-images.s3-accelerate.amazonaws.com/"
    
    static let BetaUserKey = "beta_user"
    static let WashServicesKey = "wash_services_all_users"
    static let DebugUserKey = "debug_user"
    
    static let PushNotificationSettingsKey = "push_notification_settings"
    static let FuelOffersEnabledKey = "fuel_offers_enabled"
    static let HasSignedOutKey = "has_signed_out"
    static let SubscriptionSelectionKey = "subscription_selection"
}
