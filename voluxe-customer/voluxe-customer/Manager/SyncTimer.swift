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
    private var state: State = .suspended
    
    init(booking: Booking) {
        self.booking = booking
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
        if booking.isInvalidated {
            // todo remove from manager?
            return
        }
        // todo define timer for states
        if booking.pickupRequest != nil || booking.dropoffRequest != nil {
            if booking.getState() != .serviceCompleted && booking.getState() != .completed && booking.getState() != .canceled {
                if booking.getState() == .enRouteForPickup || booking.getState() == .enRouteForDropoff {
                    syncBooking(every: 10)
                } else {
                    syncBooking(every: 60)
                }
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
            timer.setEventHandler(handler: {
                if UserManager.sharedInstance.getAccessToken() == nil || self.booking.isInvalidated {
                    self.suspend()
                    return
                }
                if let customerId = UserManager.sharedInstance.getCustomerId() {
                    self.getBooking(customerId: customerId, bookingId: self.booking.id)
                }
            })
            self.resume()
        }
    }
    
    
    private func getBooking(customerId: Int, bookingId: Int) {
        if Config.sharedInstance.isMock {
            return
        }
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
                StateServiceManager.sharedInstance.updateState(state: serviceState, vehicleId: booking.vehicleId)
            } else {
                // error
            }
            
            }.onFailure { error in
                // todo show error
        }
    }
    
    
    
}
