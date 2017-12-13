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
    
    static func logEventWithName(_ eventName: String) {
        Analytics.logEvent(eventName, parameters: nil)
    }
    
    static func logEventWithName(_ eventName: String, parameters: [String:String]) {
        Analytics.logEvent(eventName, parameters: parameters)
    }
}
