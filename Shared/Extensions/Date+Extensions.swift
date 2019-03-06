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

    // Date from today at 11:59:59pm in local time zone.
    static func latestToday() -> Date {
        let startOfDay = Date.earliestToday()
        var components = DateComponents()
        components.day = 1
        components.second = -1
        let date = Calendar.current.date(byAdding: components, to: startOfDay)
        return date ?? Date()
    }

    // Date from today plus 7 days at 11:59:59pm in local time zone.
    static func oneWeekFromToday() -> Date {
        var components = DateComponents()
        components.day = 8
        components.second = -1
        let date = Calendar.current.date(byAdding: components, to: Date.earliestToday())
        return date ?? Date()
    }

    // Is the current date after 11:59:59pm in local time zone.
    func isLaterThanToday() -> Bool {
        let endOfDay = Date.latestToday()
        let after = self > endOfDay
        return after
    }

    func isDuring(daysFromNow: Int) -> Bool {
        var components = DateComponents()
        components.day = daysFromNow
        components.second = -1
        let earliest = Calendar.current.date(byAdding: components, to: Date.earliestToday())
        let latest = Calendar.current.date(byAdding: components, to: Date.latestToday())
        if earliest == nil || latest == nil { return false }
        let afterEarliest = self >= earliest!
        let beforeLatest = self <= latest!
        return afterEarliest && beforeLatest
    }
}
