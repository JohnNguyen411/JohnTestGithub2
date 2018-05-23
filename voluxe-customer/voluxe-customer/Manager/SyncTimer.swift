//
//  SyncTimer.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 4/4/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift

class SyncTimer {
    
    private enum State {
        case suspended
        case resumed
    }
    
    var timer: DispatchSourceTimer?
    let queue = DispatchQueue.main
    let booking: Booking
    let bookingId: Int
    private var state: State = .suspended
    
    init(booking: Booking) {
        self.booking = booking
        self.bookingId = booking.id
        sync()
    }
    
    private func resume() {
        guard let timer = self.timer else { return }
        if state == .resumed {
            return
        }
        state = .resumed
        timer.resume()
    }
    
    func suspend() {
        guard let timer = self.timer else { return }
        if state == .suspended {
            return
        }
        state = .suspended
        timer.suspend()
    }
    
    deinit {
        guard let timer = self.timer else { return }
        
        timer.setEventHandler {}
        timer.cancel()
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
            // todo remove from manager?
            return
        }
        
        timer = DispatchSource.makeTimerSource(queue: queue)
        if let timer = timer {
            timer.schedule(deadline: .now(), repeating: .seconds(every), leeway: .seconds(1))
            timer.setEventHandler(handler: { [weak self] in
                guard let weakSelf = self else {
                    return
                }
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
            } else {
                // error
            }
            
            }.onFailure { error in
                // todo show error
        }
    }
    
    
    
}
