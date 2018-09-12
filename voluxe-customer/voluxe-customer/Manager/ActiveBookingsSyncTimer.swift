//
//  ActiveBookingsSyncTimer.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 6/29/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift

class ActiveBookingsSyncTimer: SyncTimer {
    
    override init() {
        super.init()
        sync()
    }
    
    public func sync() {
        syncBookings(every: Config.sharedInstance.bookingRefresh())
    }
    
    private func syncBookings(every: Int) {
        
        if let timer = timer {
            timer.setEventHandler {}
            timer.cancel()
        }
        
        if !UserManager.sharedInstance.isLoggedIn() {
            return
        }
        
        timer = DispatchSource.makeTimerSource(queue: queue)
        if let timer = timer {
            timer.schedule(deadline: .now(), repeating: .seconds(every), leeway: .seconds(1))
            timer.setEventHandler(handler: { [weak self] in
                guard let weakSelf = self else { return }
                if !UserManager.sharedInstance.isLoggedIn() {
                    weakSelf.suspend()
                    return
                }
                if let _ = UserManager.sharedInstance.customerId() {
                    weakSelf.getActiveBookings()
                }
            })
            timer.resume()
        }
    }
    
    public func getActiveBookings() {
        
        guard let customerId = UserManager.sharedInstance.customerId() else { return }
        
        // Get Customer's active Bookings based on ID
        BookingAPI().getBookings(customerId: customerId, active: true).onSuccess { result in
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
                // add the bookings
                for booking in bookings {
                    BookingSyncTimer.updateBooking(booking: booking, customerId: customerId)
                    let added = UserManager.sharedInstance.addBooking(booking: booking)
                    if added {
                        BookingSyncManager.sharedInstance.syncBookings()
                    }
                }
            }
            
            }.onFailure { error in
        }
    }
}
