//
//  RequestedServiceManager.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/17/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

/***
 *** RequestedServiceManager use to handle current Booking (currently scheduling or active booking)
 ***/
final class RequestedServiceManager {
    
    private var selfInitiated = false
    private var service: Service?
    private var dealership: Dealership?
    private var loaner: Bool = true
    
    private var pickupRequestLocation: Location?
    private var pickupTimeSlot: DealershipTimeSlot?
    
    private var dropOffRequestLocation: Location?
    private var dropOffTimeSlot: DealershipTimeSlot?
    
    private var booking: Booking?
    
    static let sharedInstance = RequestedServiceManager()
    
    init() {
    }
    
    func reset() {
        loaner = true
        pickupTimeSlot = nil
        pickupRequestLocation = nil
        dropOffRequestLocation = nil
        dropOffTimeSlot = nil
        booking = nil
    }
    
    func setBooking(booking: Booking?, updateState: Bool) {
        let serviceState = Booking.getStateForBooking(booking: booking)
        self.booking = booking
        if updateState {
            StateServiceManager.sharedInstance.updateState(state: serviceState)
        }
    }
    
    func getBooking() -> Booking? {
        return booking
    }
    
    func setService(service: Service, selfInitiated: Bool? = nil) {
        self.service = service
        if let selfInitiated = selfInitiated {
            self.selfInitiated = selfInitiated
        }
    }
    
    func setDealership(dealership: Dealership) {
        self.dealership = dealership
    }
    
    func setLoaner(loaner: Bool) {
        self.loaner = loaner
    }
    
    func getService() -> Service? {
        return service
    }
    
    func getDealership() -> Dealership? {
        return dealership
    }
    
    func getLoaner() -> Bool {
        return loaner
    }
    
    func isSelfInitiated() -> Bool {
        return selfInitiated
    }
    
    func setPickupTimeSlot(timeSlot: DealershipTimeSlot?) {
        pickupTimeSlot = timeSlot
    }
    
    func setPickupRequestLocation(requestLocation: Location) {
        pickupRequestLocation = requestLocation
    }
    
    func getPickupTimeSlot() -> DealershipTimeSlot? {
        return pickupTimeSlot
    }
    
    
    func getPickupLocation() -> Location? {
        return pickupRequestLocation
    }
    
    func setDropoffTimeSlot(timeSlot: DealershipTimeSlot?) {
        dropOffTimeSlot = timeSlot
    }
    
    func setDropoffRequestLocation(requestLocation: Location) {
        dropOffRequestLocation = requestLocation
    }
    
    func getDropoffTimeSlot() -> DealershipTimeSlot? {
        return dropOffTimeSlot
    }
    
    func getDropoffLocation() -> Location? {
        return dropOffRequestLocation
    }
    
}

