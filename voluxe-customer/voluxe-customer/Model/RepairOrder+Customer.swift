//
//  RepairOrder+Customer.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 3/14/19.
//  Copyright © 2019 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import LuxePnDSDK

extension RepairOrder {
    
    convenience init(repairOrderType: RepairOrderType) {
        self.init()
        self.title = repairOrderType.name
        self.name = repairOrderType.name
        if repairOrderType.getCategory() == .custom {
            self.name = String.localized(.viewScheduleServiceTypeOtherUnknown)
        }
        self.repairOrderType = repairOrderType
    }
    
    
    static func getDrivabilityTitle(isDrivable: Bool?) -> String {
        if let drivable = isDrivable {
            if drivable {
                return .localized(.yes)
            } else {
                return .localized(.no)
            }
        } else {
            return .localized(.imNotSure)
        }
    }
}
