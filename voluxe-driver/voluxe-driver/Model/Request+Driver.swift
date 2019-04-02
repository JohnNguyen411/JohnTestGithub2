//
//  Request+Driver.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 4/1/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation

extension Request {
    
    var dealershipTimeSlot: DealershipTimeSlot {
        return timeSlot!
    }
    
    var isDropOff: Bool {
        return self.type == .advisorPickup || self.type == .dropoff
    }
    
    var isPickup: Bool {
        return self.type == .advisorPickup || self.type == .pickup
    }
    
    var isStarted: Bool {
        return self.state == .started
    }
    
    var isCompleted: Bool {
        return self.state == .completed
    }
    
    var hasLoaner: Bool {
        return self.booking?.loanerVehicle != nil
    }
    
    var typeString: String {
        return self.isPickup ? .localized(.pickup) : .localized(.delivery)
    }
}
