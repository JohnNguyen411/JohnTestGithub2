//
//  RepairOrder.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 1/16/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreLocation
import RealmSwift

class RepairOrder: Object, Mappable {
    
    
    @objc dynamic var id: Int = -1
    @objc dynamic var bookingId: Int = -1
    @objc dynamic var dealershipRepairOrderId: Int = -1
    @objc dynamic var price: Int = -1
    @objc dynamic var currencyId: Int = -1
    @objc dynamic var state: String?
    

    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        bookingId <- map["booking_id"]
        dealershipRepairOrderId <- map["dealership_repair_order_id"]
        price <- map["price"]
        currencyId <- map["currency_id"]
        state <- map["state"]
    }
    
}
