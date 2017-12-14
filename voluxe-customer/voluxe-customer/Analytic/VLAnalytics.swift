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
    
    static let needServiceScreen = "needServiceScreen"
    static let serviceTypeParam = "serviceType"

    
    static let stateChangeEvent = "stateChange"
    static let stateParam = "state"
    
    static func logEventWithName(_ eventName: String) {
        Analytics.logEvent(eventName, parameters: nil)
    }
    
    static func logEventWithName(_ eventName: String, paramName: String, paramValue: String) {
        Analytics.logEvent(eventName, parameters: [paramName : paramValue])
    }
    
    static func logEventWithName(_ eventName: String, parameters: [String:String]) {
        Analytics.logEvent(eventName, parameters: parameters)
    }
}
