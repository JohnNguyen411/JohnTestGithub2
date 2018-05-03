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
    
    private var timers: [Int: SyncTimer?] = [:]
    static let sharedInstance = BookingSyncManager()
    
    public func syncBookings() {
        if UserManager.sharedInstance.getBookings().count > 0 {
            for booking in UserManager.sharedInstance.getBookings() {
                if booking.isInvalidated {
                    if var timer = timers[booking.id] {
                        if timer != nil {
                            timer!.suspend()
                        }
                        timers.removeValue(forKey: booking.id)
                        timer = nil
                    }
                    
                    continue
                }
                
                if let timer = timers[booking.id], timer != nil {
                    timer!.sync()
                } else {
                    let newTimer = SyncTimer(booking: booking)
                    timers[booking.id] = newTimer
                }
            }
        } else {
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
    }
}
