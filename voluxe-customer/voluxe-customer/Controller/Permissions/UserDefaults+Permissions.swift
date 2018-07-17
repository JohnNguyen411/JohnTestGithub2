//
//  UserDefaults+Permissions.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 6/19/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation


extension UserDefaults {
    
    
    /// Indicates if Notification Permission has been ask for a state.
    /// Can be 3 states: Pickup Scheduled, Day of Pickup, Delivery Scheduled
    /// return true if should show permission screen, false otherwise
    
    func shouldShowNotifPermissionForBooking(booking: Booking) -> Bool {
        if booking.getState() == .pickupScheduled || booking.getState() == .enRouteForPickup || booking.getState() == .service {
            if booking.hasUpcomingRequestToday() {
                return !hasShownNotificationPermissionForToday
            } else {
                return !hasShownNotificationPermissionForPickup
            }
        } else if booking.getState() == .dropoffScheduled || booking.getState() == .enRouteForDropoff {
            if booking.hasUpcomingRequestToday() {
                return !hasShownNotificationPermissionForToday
            } else {
                return !hasShownNotificationPermissionForDelivery
            }
        }
        return false
    }
    
    func showNotifPermissionForBooking(booking: Booking, shouldShow: Bool) {
        if booking.getState() == .pickupScheduled || booking.getState() == .enRouteForPickup {
            if booking.hasUpcomingRequestToday() {
                hasShownNotificationPermissionForToday = shouldShow
            } else {
                hasShownNotificationPermissionForPickup = shouldShow
            }
        } else if booking.getState() == .dropoffScheduled || booking.getState() == .enRouteForDropoff {
            if booking.hasUpcomingRequestToday() {
                hasShownNotificationPermissionForToday = shouldShow
            } else {
                hasShownNotificationPermissionForDelivery = shouldShow
            }
        }
    }
    
    
    var hasShownNotificationPermissionForPickup: Bool {
        get {
            return self.bool(forKey: #function)
        }
        set {
            self.set(newValue, forKey: #function)
            self.synchronize()
        }
    }
    
    var hasShownNotificationPermissionForDelivery: Bool {
        get {
            return self.bool(forKey: #function)
        }
        set {
            self.set(newValue, forKey: #function)
            self.synchronize()
        }
    }
    
    var hasShownNotificationPermissionForToday: Bool {
        get {
            return self.bool(forKey: #function)
        }
        set {
            self.set(newValue, forKey: #function)
            self.synchronize()
        }
    }
    
   
}
