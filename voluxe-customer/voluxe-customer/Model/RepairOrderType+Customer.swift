//
//  RepairOrderType+Customer.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 3/14/19.
//  Copyright © 2019 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import LuxePnDSDK

extension RepairOrderType {
    
    static func categoryName(category: RepairOrderCategory) -> String {
        if category == .routineMaintenanceByDistance {
            return .localized(.viewScheduleServiceTypeMilestone)
        }
        return .localized(.viewScheduleServiceTypeDetailNameLabelOther)
    }
    
}
