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
    private var repairOrder: RepairOrder?
    private var dealership: Dealership?
    private var loaner: Bool = true
    
    private var pickupRequestLocation: Location?
    private var pickupTimeSlot: DealershipTimeSlot?
    private var pickupRequestType: RequestType? = nil

    private var dropOffRequestLocation: Location?
    private var dropOffTimeSlot: DealershipTimeSlot?
    private var dropOffRequestType: RequestType? = nil

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
        if let dealership = booking?.dealership {
            setDealership(dealership: dealership)
        }
        if let repairOrderRequests = booking?.repairOrderRequests, repairOrderRequests.count > 0 {
            RequestedServiceManager.sharedInstance.setRepairOrder(repairOrder: repairOrderRequests[0])
        }
    }
    
    func getBooking() -> Booking? {
        return booking
    }
    
    
    func setPickupRequestType(requestType: RequestType) {
        self.pickupRequestType = requestType
    }
    
    func setDropOffRequestType(requestType: RequestType) {
        self.dropOffRequestType = requestType
    }
    
    func getPickupRequestType() -> RequestType? {
        return pickupRequestType
    }
    
    func getDropoffRequestType() -> RequestType? {
        return dropOffRequestType
    }
    
    
    func setRepairOrder(repairOrder: RepairOrder, selfInitiated: Bool? = nil) {
        self.repairOrder = repairOrder
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
    
    func getRepairOrder() -> RepairOrder? {
        return repairOrder
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

