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
    private var isRefreshing = false
    
    static let sharedInstance = BookingSyncManager()
    
    public func fetchActiveBookings() {
        
        if isRefreshing { return }
        guard let customerId = UserManager.sharedInstance.customerId() else { return }
        
        isRefreshing = true
        // Get Customer's active Bookings based on ID
        BookingAPI().getBookings(customerId: customerId, active: true).onSuccess { result in
            self.isRefreshing = false
            if let bookings = result?.data?.result, bookings.count > 0 {
                
                for booking in bookings {
                    if booking.customerId == -1 {
                        booking.customerId = customerId
                    }
                }
                
                if let realm = try? Realm() {
                    try? realm.write {
                        realm.add(bookings, update: true)
                    }
                }
                // set the bookings
                UserManager.sharedInstance.setBookings(bookings: bookings)
                
            } else {
                UserManager.sharedInstance.setBookings(bookings: nil)
            }
            
            }.onFailure { error in
                self.isRefreshing = false
                UserManager.sharedInstance.setBookings(bookings: nil)
        }
    }
    
    
    public func syncBookings() {
        
        stopAllTimers()
        
        if UserManager.sharedInstance.getBookings().count == 0 {
            return
        }
        
        for booking in UserManager.sharedInstance.getBookings() {
            if booking.isInvalidated {
                continue
            }
            
            let newTimer = SyncTimer(booking: booking)
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
    }
}
