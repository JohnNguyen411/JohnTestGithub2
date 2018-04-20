//
//  VLAnalytics.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 12/13/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import FirebaseAnalytics

class VLAnalytics {
    
    
    static func logEventWithName(_ eventName: String, screenName: String? = nil, index: Int? = nil) {
        var params: [String: Any] = [:]
        if let screenName = screenName {
            params[AnalyticsConstants.paramScreenName] = screenName
        }
        if let index = index {
            params[AnalyticsConstants.paramNameIndex] = index
        }
        
        if params.count > 0 {
            Analytics.logEvent(eventName, parameters: params)
        } else {
            Analytics.logEvent(eventName, parameters: nil)
        }
    }
    
    static func logEventWithName(_ eventName: String, screenName: String? = nil) {
        if let screenName = screenName {
            Analytics.logEvent(eventName, parameters: [AnalyticsConstants.paramScreenName : screenName])
        } else {
            Analytics.logEvent(eventName, parameters: nil)
        }
    }
    
    static func logEventWithName(_ eventName: String, paramName: String, paramValue: String) {
        Analytics.logEvent(eventName, parameters: [paramName : paramValue])
    }
    
    static func logEventWithName(_ eventName: String, parameters: [String: String]) {
        Analytics.logEvent(eventName, parameters: parameters)
    }
    
    static func logErrorEventWithName(_ eventName: String, screenName: String? = nil, statusCode: Int? = nil, errorCode: String? = nil) {
        var params: [String: Any] = [:]
        if let screenName = screenName {
            params[AnalyticsConstants.paramScreenName] = screenName
        }
        if let statusCode = statusCode {
            params[AnalyticsConstants.paramStatusCode] = statusCode
        }
        if let errorCode = errorCode {
            params[AnalyticsConstants.paramErrorCode] = errorCode
        }
        Analytics.logEvent(eventName, parameters: params)
    }
}
