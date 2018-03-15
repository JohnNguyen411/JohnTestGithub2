//
//  Service.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/17/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Service: Object, Mappable {

    var name: String?
    var price: Double?
    var serviceDescription: String?
    var customerDescription: String?
    var drivable: DrivableType?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    convenience init(name: String?, price: Double?) {
        self.init()
        self.name = name
        self.price = price
    }
    
    convenience init(customerDescription: String?, drivable: DrivableType?) {
        self.init()
        self.name = .DiagnosticAndService
        self.customerDescription = customerDescription
        self.drivable = drivable
        self.price = 0
    }
 
    
    func mapping(map: Map) {
        name <- map["name"]
        price <- map["price"]
        serviceDescription <- map["description"]
    }
    
    
    static func mockService() -> Service {
        return Service(name: "10,000 mile check-up", price: Double(400))
    }
}

public enum DrivableType {
    case yes
    case no
    case notSure
}
