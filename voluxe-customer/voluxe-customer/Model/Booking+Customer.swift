//
//  Booking+Customer.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 3/13/19.
//  Copyright © 2019 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

extension Booking {
    
    public func getRefreshTime() -> Int {
        let snappedPointsFeature = RemoteConfigManager.sharedInstance.getBoolValue(key: RemoteConfigManager.snappedPointsKey)
        var refreshTime = 0
        if pickupRequest != nil || dropoffRequest != nil {
            if getState() != .completed && getState() != .canceled {
                if let pickupRequest = pickupRequest, let dealership = dealership, (getState() == .enRouteForPickup || getState() == .nearbyForPickup) {
                    let distanceFromDestination = self.distanceFromDestination(request: pickupRequest)
                    let distanceFromOrigin = self.distanceFromOrigin(request: pickupRequest, dealership: dealership)
                    // if driver is close to dealership or destination
                    if let distanceFromDestination = distanceFromDestination, let distanceFromOrigin = distanceFromOrigin,
                        distanceFromDestination < Booking.distanceTrigger || distanceFromOrigin < Booking.distanceTrigger {
                        refreshTime = Booking.refreshEnRouteClose
                    } else {
                        refreshTime = Booking.refreshEnRoute
                    }
                    
                    // if the SnappedPoint feature is Disabled, refresh more often when in route
                    if !snappedPointsFeature {
                        refreshTime = refreshTime/2
                    }
                } else if let dropoffRequest = dropoffRequest, let dealership = dealership, (getState() == .enRouteForDropoff || getState() == .nearbyForDropoff) {
                    let distanceFromDestination = self.distanceFromDestination(request: dropoffRequest)
                    let distanceFromOrigin = self.distanceFromOrigin(request: dropoffRequest, dealership: dealership)
                    // if driver is close to dealership or destination
                    if let distanceFromDestination = distanceFromDestination, let distanceFromOrigin = distanceFromOrigin,
                        distanceFromDestination < Booking.distanceTrigger || distanceFromOrigin < Booking.distanceTrigger {
                        refreshTime = Booking.refreshEnRouteClose
                    } else {
                        refreshTime = Booking.refreshEnRoute
                    }
                    
                    // if the SnappedPoint feature is Disabled, refresh more often when in route
                    if !snappedPointsFeature {
                        refreshTime = refreshTime/2
                    }
                    
                } else {
                    refreshTime = Config.sharedInstance.bookingRefresh()
                }
            }
        }
        
        return refreshTime
    }
    
    public static func getStateForBooking(booking: Booking?) -> ServiceState {
        if let booking = booking {
            return ServiceState.appStateForBookingState(bookingState: booking.getState())
        }
        return .idle
    }
    
    
}
