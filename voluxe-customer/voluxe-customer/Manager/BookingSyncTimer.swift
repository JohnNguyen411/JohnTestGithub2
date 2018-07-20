//
//  BookingSyncTimer.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 6/29/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift

class BookingSyncTimer: SyncTimer {
    
    
    let booking: Booking
    let bookingId: Int
    
    init(booking: Booking) {
        self.booking = booking
        self.bookingId = booking.id
        super.init()
        sync()
    }
    
    public func sync() {
        if booking.isInvalidated || booking.getState() == .canceled || booking.getState() == .completed {
            BookingSyncManager.sharedInstance.stopTimerForBooking(bookingId: bookingId)
            return
        }
        if booking.pickupRequest != nil || booking.dropoffRequest != nil {
            
            let refreshRate = booking.getRefreshTime()
            if refreshRate > 0 {
                syncBooking(every: refreshRate)
            }
        }
    }
    
    private func syncBooking(every: Int) {
        
        if let timer = timer {
            timer.setEventHandler {}
            timer.cancel()
        }
        
        if booking.isInvalidated {
            return
        }
        
        timer = DispatchSource.makeTimerSource(queue: queue)
        if let timer = timer {
            timer.schedule(deadline: .now(), repeating: .seconds(every), leeway: .seconds(1))
            timer.setEventHandler(handler: { [weak self] in
                guard let weakSelf = self else { return }
                if !UserManager.sharedInstance.isLoggedIn() || weakSelf.booking.isInvalidated {
                    weakSelf.suspend()
                    return
                }
                if let customerId = UserManager.sharedInstance.customerId() {
                    weakSelf.getBooking(customerId: customerId, bookingId: weakSelf.bookingId)
                }
            })
            timer.resume()
        }
    }
    
    
    private func getBooking(customerId: Int, bookingId: Int) {
        // Get Customer's Vehicles based on ID
        BookingAPI().getBooking(customerId: customerId, bookingId: bookingId).onSuccess { result in
            if let booking = result?.data?.result {
                BookingSyncTimer.updateBooking(booking: booking, customerId: customerId)
            }
            
            }.onFailure { error in
        }
    }
    
    public static func updateBooking(booking: Booking, customerId: Int) {
        if let realm = try? Realm() {
            try? realm.write {
                if booking.customerId == -1 {
                    booking.customerId = customerId
                }
                realm.add(booking, update: true)
            }
        }
        let serviceState = Booking.getStateForBooking(booking: booking)
        StateServiceManager.sharedInstance.updateState(state: serviceState, vehicleId: booking.vehicleId, booking: booking)
    }
}
