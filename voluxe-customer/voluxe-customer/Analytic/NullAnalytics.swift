//
//  NullAnalytics.swift
//  voluxe-customer
//
//  Created by Christoph on 6/28/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

/// Class that no-ops all Analytics.trackXXX() calls.
/// Useful for test targets that should not contribute
/// to app analytics.
class NullAnalytics: AnalyticsCore {

    override func track(event: AnalyticsEnums.Event,
                        element: AnalyticsEnums.Element,
                        name: AnalyticsEnums.Name.RawValue,
                        params: AnalyticsEnums.Params?)
    {
        // this space intentionally not left black
    }
}

let Analytics = NullAnalytics()
