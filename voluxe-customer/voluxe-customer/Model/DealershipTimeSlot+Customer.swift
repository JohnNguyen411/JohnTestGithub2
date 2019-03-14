//
//  DealershipTimeSlot+Customer.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 3/13/19.
//  Copyright © 2019 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

extension DealershipTimeSlot {
    
    func getTimeSlot(calendar: Calendar, showAMPM: Bool, shortSymbol: Bool? = nil) -> String? {
        guard let from = from, let to = to else { return nil }
        
        if showAMPM {
            let hourFrom = Calendar.current.component(.hour, from: from)
            let hourTo = Calendar.current.component(.hour, from: to)
            
            if hourFrom < 12 && hourTo < 12 {
                return "\(Date.formatHourMin(date: from, calendar: calendar, showAMPM: false, shortSymbol: shortSymbol))–\(Date.formatHourMin(date: to, calendar: calendar, showAMPM: showAMPM, shortSymbol: shortSymbol))"
            } else if hourFrom >= 12 && hourTo > 12 {
                return "\(Date.formatHourMin(date: from, calendar: calendar, showAMPM: false, shortSymbol: shortSymbol))–\(Date.formatHourMin(date: to, calendar: calendar, showAMPM: showAMPM, shortSymbol: shortSymbol))"
            } else {
                return "\(Date.formatHourMin(date: from, calendar: calendar, showAMPM: showAMPM, shortSymbol: shortSymbol))–\(Date.formatHourMin(date: to, calendar: calendar, showAMPM: showAMPM, shortSymbol: shortSymbol))"
            }
            
        } else {
            return "\(Date.formatHourMin(date: from, calendar: calendar, showAMPM: showAMPM, shortSymbol: shortSymbol))–\(Date.formatHourMin(date: to, calendar: calendar, showAMPM: showAMPM, shortSymbol: shortSymbol))"
        }
    }
    
}
