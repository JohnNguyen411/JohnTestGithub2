//
//  Request.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/17/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import ObjectMapper

class Request: NSObject, Mappable {
    
    private var requestLocation: RequestLocation?
    private var date: Date?
    private var timeMin: Int?
    private var timeMax: Int?
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
    }
    
    func setRequestLocation(requestLocation: RequestLocation) {
        self.requestLocation = requestLocation
    }
    
    func setRequestDate(date: Date) {
        self.date = date
    }
    
    func setTimeMin(timeMin: Int) {
        self.timeMin = timeMin
    }
    
    func setTimeMax(timeMax: Int) {
        self.timeMax = timeMax
    }
    
    func getRequestLocation() -> RequestLocation? {
        return requestLocation
    }
    
    func getRequestDate() -> Date? {
        return date
    }
    
    func getTimeMin() -> Int? {
        return timeMin
    }
    
    func getTimeMax() -> Int? {
        return timeMax
    }
    
    
}
