//
//  RequestedServiceManager.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/17/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

final class RequestedServiceManager {
    
    private var service: Service?
    private var dealership: Dealership?
    private var loaner: Bool?
    
    private var pickupRequest: Request?
    private var dropOffRequest: Request?
    
    private var booking: Booking?
    
    static let sharedInstance = RequestedServiceManager()
    
    init() {
    }
    
    private func initPickupIfNeeded() {
        if pickupRequest == nil {
            pickupRequest = Request()
        }
    }
    
    private func initDropoffIfNeeded() {
        if dropOffRequest == nil {
            dropOffRequest = Request()
        }
    }
    
    func reset() {
        loaner = nil
        pickupRequest = nil
        dropOffRequest = nil
    }
    
    func setBooking(booking: Booking?) {
        self.booking = booking
    }
    
    func setService(service: Service) {
        self.service = service
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
    
    func getLoaner() -> Bool? {
        return loaner
    }
    
    func setPickupDate(date: Date) {
        initPickupIfNeeded()
        pickupRequest?.setRequestDate(date: date)
    }
    
    func setPickupTimeRange(min: Int, max: Int) {
        initPickupIfNeeded()
        pickupRequest?.setTimeMin(timeMin: min)
        pickupRequest?.setTimeMax(timeMax: max)
    }
    
    func setPickupRequestLocation(requestLocation: RequestLocation) {
        initPickupIfNeeded()
        pickupRequest?.setRequestLocation(requestLocation: requestLocation)
    }
    
    func getPickupDate() -> Date? {
        if let pickupRequest = pickupRequest {
            return pickupRequest.getRequestDate()
        }
        return nil
    }
    
    func getPickupTimeMin() -> Int? {
        if let pickupRequest = pickupRequest {
            return pickupRequest.getTimeMin()
        }
        return nil
    }
    
    func getPickupTimeMax() -> Int? {
        if let pickupRequest = pickupRequest {
            return pickupRequest.getTimeMax()
        }
        return nil
    }
    
    func getPickupLocation() -> RequestLocation? {
        if let pickupRequest = pickupRequest {
            return pickupRequest.getRequestLocation()
        }
        return nil
    }
    
    
    
    
    func setDropoffDate(date: Date) {
        initDropoffIfNeeded()
        dropOffRequest?.setRequestDate(date: date)
    }
    
    func setDropoffTimeRange(min: Int, max: Int) {
        initDropoffIfNeeded()
        dropOffRequest?.setTimeMin(timeMin: min)
        dropOffRequest?.setTimeMax(timeMax: max)
    }
    
    func setDropoffRequestLocation(requestLocation: RequestLocation) {
        initDropoffIfNeeded()
        dropOffRequest?.setRequestLocation(requestLocation: requestLocation)
    }
    
    func getDropoffDate() -> Date? {
        if let dropOffRequest = dropOffRequest {
            return dropOffRequest.getRequestDate()
        }
        return nil
    }
    
    func getDropoffTimeMin() -> Int? {
        if let dropOffRequest = dropOffRequest {
            return dropOffRequest.getTimeMin()
        }
        return nil
    }
    
    func getDropoffTimeMax() -> Int? {
        if let dropOffRequest = dropOffRequest {
            return dropOffRequest.getTimeMax()
        }
        return nil
    }
    
    func getDropoffLocation() -> RequestLocation? {
        if let dropOffRequest = dropOffRequest {
            return dropOffRequest.getRequestLocation()
        }
        return nil
    }
    
    
}

