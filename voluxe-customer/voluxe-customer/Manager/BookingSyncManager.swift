//
//  BookingSyncManager.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 1/22/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift

final class BookingSyncManager {
    
    private var activeBookingTimer: ActiveBookingsSyncTimer?
    private var timers: [Int: BookingSyncTimer?] = [:]
    private var isRefreshing = false
    
    static let sharedInstance = BookingSyncManager()
    
    public func syncBookings() {
        
        stopAllBookingsTimers()
        
        if activeBookingTimer == nil {
            activeBookingTimer = ActiveBookingsSyncTimer()
        } else if let activeBookingTimer = activeBookingTimer, activeBookingTimer.state == .suspended {
            activeBookingTimer.sync()
        }
        
        if UserManager.sharedInstance.getBookings().count == 0 {
            return
        }
        
        for booking in UserManager.sharedInstance.getBookings() {
            if booking.isInvalidated {
                continue
            }
            
            let newTimer = BookingSyncTimer(booking: booking)
            timers[booking.id] = newTimer
        }
        
    }
    
    public func stopTimerForBooking(bookingId: Int) {
        if timers.count > 0 {
            if var timer = timers[bookingId] {
                timer?.suspend()
                timers.removeValue(forKey: bookingId)
                timer = nil
            }
        }
    }
    
    public func stopAllTimers() {
        timers.forEach { syncTimer in
            var timer = syncTimer.value
            if timer != nil {
                timer!.suspend()
            }
            timer = nil
        }
        timers.removeAll()
        
        if activeBookingTimer != nil {
            activeBookingTimer!.suspend()
            activeBookingTimer = nil
        }
    }
    
    public func stopAllBookingsTimers() {
        timers.forEach { syncTimer in
            var timer = syncTimer.value
            if timer != nil {
                timer!.suspend()
            }
            timer = nil
        }
        timers.removeAll()
    }

}
