//
//  VehicleLockStatus.swift
//  hse
//
//  Created by Kimmo Lahdenkangas on 17/10/16.
//  Copyright © 2016 Volvo. All rights reserved.
//

import Foundation
import ObjectMapper

class VehicleLockStatus: NSObject, Mappable {

    var locked: Bool!
    var timestamp: Date!

    init(locked: Bool, timestamp: Date) {
        self.locked = locked
        self.timestamp = timestamp
    }

    init(dict: [String : AnyObject]) {
        let dateFormatter = VehicleLockStatus.getDateFormatter()
        self.locked = Bool(dict["locked"] as! Bool)
        self.timestamp = dateFormatter.date(from: dict["locksTimeStamp"] as! String)!
    }

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        locked <- map["locked"]
        timestamp <- (map["locksTimeStamp"], ISO8601DateTransform())
    }

    static func getDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ" //iso 8601
        dateFormatter.locale = Locale(identifier: "en-US")
        return dateFormatter
    }

}
