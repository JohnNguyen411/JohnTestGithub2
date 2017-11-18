//
//  Date+DateTools.swift
//  hse
//
//  Created by Vinicius Egidio  on /172/17.
//  Copyright © 2017 Volvo. All rights reserved.
//

import Foundation
import DateToolsSwift

enum TimeUnit {
    case second, minute, hour, day, week, month, year
}

extension Date {

    func add(_ time: Int, unit: TimeUnit) -> Date {
        var chunk: TimeChunk

        switch unit {
        case .second: chunk = TimeChunk(seconds: time, minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: 0)
        case .minute: chunk = TimeChunk(seconds: 0, minutes: time, hours: 0, days: 0, weeks: 0, months: 0, years: 0)
        case .hour: chunk = TimeChunk(seconds: 0, minutes: 0, hours: time, days: 0, weeks: 0, months: 0, years: 0)
        case .day: chunk = TimeChunk(seconds: 0, minutes: 0, hours: 0, days: time, weeks: 0, months: 0, years: 0)
        case .week: chunk = TimeChunk(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: time, months: 0, years: 0)
        case .month: chunk = TimeChunk(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: time, years: 0)
        case .year: chunk = TimeChunk(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: time)
        }

        return self.add(chunk)
    }

    /**
     The current NSTime, without the time components; in other words, the beginning of the day.

     - returns: `Date` object.
     */
    func dateOnly() -> Date {
        return Date(year: self.year, month: self.month, day: self.day)
    }

    /**
     The current NSTime, without the hours.

     - returns: `Date` object.
     */
    func removeHours() -> Date {
        return Date(year: self.year, month: self.month, day: self.day, hour: 0, minute: self.minute,
                    second: self.second)
    }

    /**
     The current NSTime, without the minutes.

     - returns: `Date` object.
     */
    func removeMinutes() -> Date {
        return Date(year: self.year, month: self.month, day: self.day, hour: self.hour, minute: 0, second: self.second)
    }

    /**
     The current NSTime, without the seconds.

     - returns: `Date` object.
     */
    func removeSeconds() -> Date {
        return Date(year: self.year, month: self.month, day: self.day, hour: self.hour, minute: self.minute,
                    second: 0)
    }

    /**
     The end of the current day.

     - returns: `Date` object.
     */
    func endOfDay() -> Date {
        return Date(year: self.year, month: self.month, day: self.day, hour: 23, minute: 59, second: 59)
    }

    static func < (a: Date, b: Date) -> Bool {
        return a.compare(b) == ComparisonResult.orderedAscending
    }

    static func <= (a: Date, b: Date) -> Bool {
        return a.compare(b) == ComparisonResult.orderedAscending || a.compare(b) == ComparisonResult.orderedSame
    }

    static func >= (a: Date, b: Date) -> Bool {
        return a.compare(b) == ComparisonResult.orderedDescending || a.compare(b) == ComparisonResult.orderedSame
    }

    static func == (a: Date, b: Date) -> Bool {
        return a.compare(b) == ComparisonResult.orderedSame
    }
    
    public static func formatHourRange(min: Int, max: Int) -> String {
        let gregorian = Calendar(identifier: .gregorian)
        let now = Date()
        var components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
        
        components.hour = min
        components.minute = 00
        components.second = 0
        
        let dateString : String = DateFormatter.dateFormat(fromTemplate: "j:mm", options: 0, locale: Locale.current)!
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = dateString
        
        let dateMin = gregorian.date(from: components)!
        
        components.hour = max

        let dateMax = gregorian.date(from: components)!

        let minTime = hourFormatter.string(from: dateMin)
        let maxTime = hourFormatter.string(from: dateMax)

        return "\(minTime) \(maxTime)"
    }

}
