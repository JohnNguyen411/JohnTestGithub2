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
            self.firebaseLogEvent(eventName, parameters: params)
        } else {
            self.firebaseLogEvent(eventName, parameters: nil)
        }
    }
    
    static func logEventWithName(_ eventName: String, screenName: String? = nil) {
        if let screenName = screenName {
            self.firebaseLogEvent(eventName, parameters: [AnalyticsConstants.paramScreenName : screenName])
        } else {
            self.firebaseLogEvent(eventName, parameters: nil)
        }
    }
    
    static func logEventWithName(_ eventName: String, paramName: String, paramValue: String) {
        self.firebaseLogEvent(eventName, parameters: [paramName : paramValue])
    }
    
    static func logEventWithName(_ eventName: String, paramName: String, paramValue: String, screenName: String) {
        self.firebaseLogEvent(eventName, parameters: [paramName : paramValue, AnalyticsConstants.paramScreenName : screenName])
    }
    
    static func logEventWithName(_ eventName: String, parameters: [String: String]) {
        self.firebaseLogEvent(eventName, parameters: parameters)
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
        self.firebaseLogEvent(eventName, parameters: params)
    }

    /// Private method to wrap the actual Firebase log event call.
    /// If Firebase has been disabled from the debug menu, this is
    /// a no-op.  Because the UserDefaults check will happen a lot,
    /// the check is only done for DEBUG builds.
    static private func firebaseLogEvent(_ eventName: String, parameters params: [String: Any]?) {
        #if DEBUG
            guard UserDefaults.standard.disableFirebase == false else { return }
        #endif
        Analytics.logEvent(eventName, parameters: params)
    }
}
