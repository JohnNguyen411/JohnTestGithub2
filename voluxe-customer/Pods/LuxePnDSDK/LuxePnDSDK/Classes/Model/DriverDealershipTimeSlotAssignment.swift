//
//  DriverDealershipTimeSlotAssignment.swift
//  LuxePnDSDK
//
//  Created by Johan Giroux on 4/1/19.
//

import Foundation

@objcMembers public class DriverDealershipTimeSlotAssignment: NSObject, Codable {
    
    public dynamic var id: Int
    public dynamic var driverId: Int?
    public dynamic var dealershipTimeSlotId: Int
    public dynamic var state: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case driverId = "driver_id"
        case dealershipTimeSlotId = "dealership_time_slot_id"
        case state
    }
}
