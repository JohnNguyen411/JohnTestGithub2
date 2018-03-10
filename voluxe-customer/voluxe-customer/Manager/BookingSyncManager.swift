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
    
    private enum State {
        case suspended
        case resumed
    }
    
    var timer: DispatchSourceTimer?
    let queue = DispatchQueue.main
    private var state: State = .suspended
    static let sharedInstance = BookingSyncManager()
    
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
    
    public func syncBooking() {
        if let booking = RequestedServiceManager.sharedInstance.getBooking() {
            // todo define timer for states
            if booking.pickupRequest != nil || booking.dropoffRequest != nil {
                if booking.getState() != .serviceCompleted && booking.getState() != .completed {
                    syncBooking(every: 10)
                }
            } else {
                suspend()
            }

        }
    }
    
    private func syncBooking(every: Int) {
        
        if let timer = timer {
            timer.setEventHandler {}
            timer.cancel()
        }
        
        timer = DispatchSource.makeTimerSource(queue: queue)
        if let timer = timer {
            timer.schedule(deadline: .now(), repeating: .seconds(every), leeway: .seconds(1))
            timer.setEventHandler(handler: {
                if UserManager.sharedInstance.getAccessToken() == nil {
                    self.suspend()
                    return
                }
                if let customerId = UserManager.sharedInstance.getCustomerId(), let booking = RequestedServiceManager.sharedInstance.getBooking() {
                    self.getBooking(customerId: customerId, bookingId: booking.id)
                } else {
                    self.suspend()
                }
            })
            timer.resume()
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
                        realm.add(booking, update: true)
                    }
                }
                RequestedServiceManager.sharedInstance.setBooking(booking: booking, updateState: true)
            } else {
                // error
                StateServiceManager.sharedInstance.updateState(state: .needService)
            }
            
            }.onFailure { error in
                // todo show error
                StateServiceManager.sharedInstance.updateState(state: .needService)
        }
    }
    
    
}
