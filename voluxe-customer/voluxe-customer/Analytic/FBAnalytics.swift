//
//  FBAnalytics.swift
//  voluxe-customer
//
//  Created by Christoph on 6/18/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import FirebaseAnalytics
import Foundation

// global access for analytics
let Analytics = FBAnalytics()

/// Subclass of AnalyticsCore with a Firebase Analytics implementation.
class FBAnalytics: AnalyticsCore {

    /// Returns a underscored string that has merged the arguments.
    /// This is the preferred key format for Firebase.
    private func eventName(event: AnalyticsEnums.Event,
                           element: AnalyticsEnums.Element,
                           name: AnalyticsEnums.Name.RawValue) -> String
    {
        let strings = [event.rawValue, element.rawValue, name]
        let merged = strings.joined(separator: "_")
        return merged
    }

    /// Transforms the AnalyticsEnum.Params dictionary into a Firebase
    /// compatible [String: Any] dictionary.
    private func firebaseParams(params: AnalyticsEnums.Params?) -> [String: Any]? {
        guard let params = params, params.isEmpty == false else { return nil }
        let keys = params.keys.map { $0.rawValue }
        let firebaseParams = Dictionary(uniqueKeysWithValues: zip(keys, params.values))
        return firebaseParams
    }

    /// Convenience closure to catch the output that is going into
    /// the Firebase analytics call.  This is useful for testing and
    /// generating the shake-to-debug menu's analytics taxonomy.
    /// If this is set, no events will be sent to Firebase.
    var trackOutputClosure: ((String, [String: Any]?) -> ())?

    /// Private method to wrap the actual Firebase log event call.
    /// If Firebase has been disabled from the debug menu, this is
    /// a no-op.  Because the UserDefaults check will happen a lot,
    /// the check is only done for DEBUG builds.
    internal override func track(event: AnalyticsEnums.Event,
                                 element: AnalyticsEnums.Element,
                                 name: AnalyticsEnums.Name.RawValue,
                                 params: AnalyticsEnums.Params? = nil)
    {
        let eventName = self.eventName(event: event, element: element, name: name)
        let firebaseParams = self.firebaseParams(params: params)

        if let closure = self.trackOutputClosure {
            closure(eventName, firebaseParams)
            return
        }

        #if DEBUG
            guard UserDefaults.standard.disableFirebase == false else { return }
        #endif
        FirebaseAnalytics.Analytics.logEvent(eventName, parameters: firebaseParams)
    }
}
