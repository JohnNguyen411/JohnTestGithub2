//
//  Date+Extensions.swift
//  voluxe-driver
//
//  Created by Christoph on 12/5/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation

extension Date {

    // Date from today at 12:00:00am in local time zone.
    static func earliestToday() -> Date {
        let date = Calendar.current.startOfDay(for: Date())
        return date
    }

    // Date from today plus 6 days at 11:59:59pm in local time zone.
    static func oneWeekFromToday() -> Date {
        var components = DateComponents()
        components.day = 7
        components.second = -1
        let date = Calendar.current.date(byAdding: components, to: Date.earliestToday())
        guard date != nil else { return Date() }
        return date!
    }
}
