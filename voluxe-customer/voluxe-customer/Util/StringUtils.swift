//
//  StringUtils.swift
//  hse
//
//  Created by Kimmo Lahdenkangas on 26/05/16.
//  Copyright © 2016 Volvo. All rights reserved.
//

import Foundation
import DateToolsSwift
import UIKit

class StringUtils {

    class func toCurrencyString(num: Float) -> String? {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: num))
    }

    class func toAmountString(num: Float) -> String? {
        return toCurrencyString(num: num)
    }

    class func toCurrencyString(num: Double) -> String? {
        return toCurrencyString(num: Float(num))
    }

    class func dateTimeIntervalString(startTime: Date, endTime: Date?) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none

        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "en_US")
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short

        if (endTime == nil || dateFormatter.string(from: startTime) == dateFormatter.string(from: endTime!)) {
            var str = "\(dateFormatter.string(from: startTime)) \(timeFormatter.string(from: startTime))"
            if (endTime != nil && timeFormatter.string(from: startTime) != timeFormatter.string(from: endTime!)) {
                str += " - \(timeFormatter.string(from: endTime!))"
            }
            return str
        } else {
            return "\(dateFormatter.string(from: startTime)) \(timeFormatter.string(from: startTime)) - \(dateFormatter.string(from: endTime!)) \(timeFormatter.string(from: endTime!))"
        }
    }

    class func timeIntervalString(startTime: Date, endTime: Date?) -> String? {
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "en_US")
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short

        var str = "\(timeFormatter.string(from: startTime))"
        if (endTime != nil && timeFormatter.string(from: startTime) != timeFormatter.string(from: endTime!)) {
            str += " - \(timeFormatter.string(from: endTime!))"
        }
        return str
    }

    class func formattedTimeIntervalStringBig(startTime: Date, endTime: Date?, oneLine: Bool) -> NSAttributedString? {
        let timeFormatter = DateFormatter()
        let timeOfDayFormatter = DateFormatter()
        let dayLabelFormatter = DateFormatter()

        timeFormatter.locale = Locale(identifier: "en_US")
        timeOfDayFormatter.locale = Locale(identifier: "en_US")
        dayLabelFormatter.locale = Locale(identifier: "en_US")

        timeFormatter.dateFormat = "h"
        timeOfDayFormatter.dateFormat = "a"

        dayLabelFormatter.dateFormat = "EEE"

        let formattedTimeIntervalText = NSMutableAttributedString()

        let today = Calendar.current.component(.day, from: Date())

        let dayOnQuote = Calendar.current.component(.day, from: startTime)
        if today != dayOnQuote {
            if (oneLine) {
                formattedTimeIntervalText.append(Fonts.B2_Blue(text: dayLabelFormatter.string(from: startTime).capitalized + " "))
            } else {
                formattedTimeIntervalText.append(Fonts.B2_Blue(text: dayLabelFormatter.string(from: startTime).capitalized + "\n"))
            }

        }

        formattedTimeIntervalText.append(Fonts.B2_Blue(text: timeFormatter.string(from: startTime)))
        formattedTimeIntervalText.append(Fonts.B4_Blue(text: timeOfDayFormatter.string(from: startTime)))

        if (endTime != nil) {
            formattedTimeIntervalText.append(Fonts.B2_Blue(text: " - "))
            formattedTimeIntervalText.append(Fonts.B2_Blue(text: timeFormatter.string(from: endTime!)))
            formattedTimeIntervalText.append(Fonts.B4_Blue(text: timeOfDayFormatter.string(from: endTime!)))
        }

        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 4
        formattedTimeIntervalText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraph, range: NSRange(location: 0, length: formattedTimeIntervalText.string.utf8.count))

        return formattedTimeIntervalText
    }

    class func formattedTimeIntervalString(startTime: Date, endTime: Date?, oneLine: Bool) -> NSAttributedString? {
        let timeFormatter = DateFormatter()
        let timeOfDayFormatter = DateFormatter()
        let dayLabelFormatter = DateFormatter()

        timeFormatter.locale = Locale(identifier: "en_US")
        timeOfDayFormatter.locale = Locale(identifier: "en_US")
        dayLabelFormatter.locale = Locale(identifier: "en_US")

        timeFormatter.dateFormat = "h"
        timeOfDayFormatter.dateFormat = "a"
        dayLabelFormatter.dateFormat = "EEEE"

        let formattedTimeIntervalText = NSMutableAttributedString()
        let today = Date().dateOnly()
        let tomorrow = today.add(1, unit: .day)
        let dayOnQuote = startTime.dateOnly()
        var dateName = ""

        if dayOnQuote == today {
            dateName = "TODAY"
        } else if dayOnQuote == tomorrow {
            dateName = "TOMORROW"
        } else {
            dateName = dayLabelFormatter.string(from: startTime).uppercased()
        }

        if oneLine {
            formattedTimeIntervalText.append(Fonts.B4_Black(text: dateName + " "))
        } else {
            formattedTimeIntervalText.append(Fonts.B4_Black(text: dateName + "\n"))
        }

        formattedTimeIntervalText.append(Fonts.B4_Black(text: timeFormatter.string(from: startTime)))
        formattedTimeIntervalText.append(Fonts.B4_Black(text: timeOfDayFormatter.string(from: startTime)))

        if (endTime != nil) {
            formattedTimeIntervalText.append(Fonts.B4_Black(text: " - "))
            formattedTimeIntervalText.append(Fonts.B4_Black(text: timeFormatter.string(from: endTime!)))
            formattedTimeIntervalText.append(Fonts.B4_Black(text: timeOfDayFormatter.string(from: endTime!)))
        }

        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 4
        formattedTimeIntervalText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraph, range: NSRange(location: 0, length: formattedTimeIntervalText.string.utf8.count))

        return formattedTimeIntervalText
    }

    class func time(date: Date) -> String? {
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "en_US")
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short

        return timeFormatter.string(from: date)
    }

    class func dateShortString(date: Date) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "en_US")
        timeFormatter.dateFormat = "MMM d"

        return timeFormatter.string(from: date)
    }

    class func dateMediumString(date: Date) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "en_US")
        timeFormatter.dateFormat = "MMM d, YYYY"

        return timeFormatter.string(from: date)
    }

    class func analytics(str: String?) -> String {
        return str ?? "unknown"
    }

    class func analytics(i: Int?) -> String {
        return i != nil ? String(describing: i) : "unknown"
    }

    class func analytics(d: Double?) -> String {
        return d != nil ? String(describing: d) : "unknown"
    }

    class func analytics(f: Float?) -> String {
        return f != nil ? String(describing: f) : "unknown"
    }

    class func analytics(bool: Bool?) -> String {
        return bool != nil ? String(describing: bool) : "unknown"
    }

    class func analytics(date: Date?) -> String {
        return date != nil ? date!.description : "unknown"
    }

    class func arrayToString(strings: [String]) -> String {
        if (strings.count < 1) {
            return ""
        }
        var mutableStrings = strings
        let last = mutableStrings.popLast()
        var actionTitle = last!

        if (!mutableStrings.isEmpty) {
            actionTitle = mutableStrings.joined(separator: ", ")
            actionTitle.append(" and \(last!)")
        }

        return String(actionTitle.characters.prefix(1)).uppercased() + String(actionTitle.characters.dropFirst())
    }

    class func arrayToStringTruncated(strings: [String]) -> String {
        var mutableStrings: [String] = []
        if (strings.count < 1) {
            return ""
        } else if (strings.count > 2) {
            mutableStrings = strings.enumerated().flatMap{$0.offset < 2 ? $0.element : nil}
        } else {
            mutableStrings = strings
        }
        let last = mutableStrings.popLast()
        var actionTitle = last!
        if (!mutableStrings.isEmpty) {
            actionTitle = mutableStrings.joined(separator: ", ")
            if (strings.count) > 1 {
                let numberOfMoreServices = strings.count - 1
                actionTitle.append(" & \(numberOfMoreServices) more")
            } else {
                actionTitle.append(" & \(last!)")
            }
        }
        return String(actionTitle.characters.prefix(1)).uppercased() + String(actionTitle.characters.dropFirst())
    }

}
