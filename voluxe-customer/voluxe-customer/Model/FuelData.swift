//
//  FuelData.swift
//  hse
//
//  Created by Erik Gyllensten on 29/06/16.
//  Copyright © 2016 Volvo. All rights reserved.
//

import Foundation
import ObjectMapper
import CocoaLumberjack

class FuelData: NSObject, Mappable {
    var amountRemaining: Int?
    var amountRemainingTimeStamp: Date?
    var currentLevel: Int?
    var currentLevelTimeStamp: Date?
    var consumptionAverage: Float64?
    var consumptionAverageTimeStamp: Date?
    var distanceToEmpty: Int?
    var distanceToEmptyTimeStamp: Date?

    var tankCapacity: Int {
        if let amount = amountRemaining, let percentage = currentLevel {
            return amount * 100 / percentage
        } else {
            return 0
        }
    }

    init(amountRemaining: Int?, amountRemainingTimeStamp: Date?, currentLevel: Int?, currentLevelTimeStamp: Date?, consumptionAverage: Float64?, consumptionAverageTimeStamp: Date?, distanceToEmpty: Int?, distanceToEmptyTimeStamp: Date?) {
        self.amountRemaining = amountRemaining
        self.amountRemainingTimeStamp = amountRemainingTimeStamp
        self.currentLevel = currentLevel
        self.currentLevelTimeStamp = currentLevelTimeStamp
        self.consumptionAverage = consumptionAverage
        self.consumptionAverageTimeStamp = consumptionAverageTimeStamp
        self.distanceToEmpty = distanceToEmpty
        self.distanceToEmptyTimeStamp = distanceToEmptyTimeStamp
    }

    init(dict: [String: AnyObject]) {
        let dateFormatter = FuelData.getDateFormatter()

        self.amountRemaining = dict["amountRemaining"] as? Int
        if let dateString = dict["amountRemainingTimeStamp"] as? String {
            self.amountRemainingTimeStamp = dateFormatter.date(from: dateString)
        }

        self.currentLevel = dict["currentLevel"] as? Int
        if let dateString = dict["currentLevelTimeStamp"] as? String {
            self.currentLevelTimeStamp = dateFormatter.date(from: dateString)
        }

        self.consumptionAverage = dict["consumptionAverage"] as? Float64
        if let dateString = dict["consumptionAverageTimeStamp"] as? String {
            self.consumptionAverageTimeStamp = dateFormatter.date(from: dateString)
        }

        self.distanceToEmpty = dict["distanceToEmpty"] as? Int
        if let dateString = dict["distanceToEmptyTimeStamp"] as? String {
            self.distanceToEmptyTimeStamp = dateFormatter.date(from: dateString)
        }
    }

    static func getDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en-US")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ" //iso 8601
        return dateFormatter
    }

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        amountRemaining <- map["amountRemaining"]
        amountRemainingTimeStamp <- (map["amountRemainingTimeStamp"], ISO8601DateTransform())
        currentLevel <- map["currentLevel"]
        currentLevelTimeStamp <- (map["currentLevelTimeStamp"], ISO8601DateTransform())
        consumptionAverage <- map["consumptionAverage"]
        consumptionAverageTimeStamp <- (map["consumptionAverageTimeStamp"], ISO8601DateTransform())
        distanceToEmpty <- map["distanceToEmpty"]
        distanceToEmptyTimeStamp <- (map["distanceToEmptyTimeStamp"], ISO8601DateTransform())
    }
}
