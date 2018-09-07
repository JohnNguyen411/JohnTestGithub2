//
//  Booking.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 1/16/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreLocation
import RealmSwift
import Realm

class Booking: Object, Mappable {
    
    private static let distanceTrigger = 500.0 // refresh more ofter when within 500m from origin or destination
    
    private static let defaultRefresh = 60
    private static let refreshEnRouteClose = 10
    private static let refreshEnRoute = 20
    
    @objc dynamic var id: Int = -1
    @objc dynamic var customerId: Int = -1
    @objc dynamic var customer: Customer?
    @objc dynamic var state: String = "created"
    @objc dynamic var vehicleId: Int = -1
    @objc dynamic var vehicle: Vehicle?
    @objc dynamic var dealershipId: Int = -1
    @objc dynamic var dealership: Dealership?
    @objc dynamic var loanerVehicleRequested: Bool = false
    @objc dynamic var loanerVehicleId: Int = -1
    @objc dynamic var loanerVehicle: Vehicle?
    @objc dynamic var pickupRequest: Request?
    @objc dynamic var pickupRequestId: Int = -1
    @objc dynamic var dropoffRequest: Request?
    @objc dynamic var dropoffRequestId: Int = -1
    @objc dynamic var bookingFeedbackId: Int = -1
    @objc dynamic var bookingFeedback: BookingFeedback?
    var repairOrderRequests = List<RepairOrder>()
    @objc dynamic var createdAt: Date?
    @objc dynamic var updatedAt: Date?

    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        customerId <- map["customer_id"]
        customer <- map["customer"]
        state <- map["state"]
        vehicleId <- map["vehicle_id"]
        vehicle <- map["vehicle"]
        dealershipId <- map["dealership_id"]
        dealership <- map["dealership"]
        loanerVehicleRequested <- map["loaner_vehicle_requested"]
        loanerVehicleId <- map["loaner_vehicle_id"]
        loanerVehicle <- map["loaner_vehicle"]
        pickupRequest <- map["pickup_request"]
        pickupRequestId <- map["pickup_request_id"]
        dropoffRequest <- map["dropoff_request"]
        dropoffRequestId <- map["dropoff_request_id"]
        bookingFeedbackId <- map["booking_feedback_id"]
        bookingFeedback <- map["booking_feedback"]
        repairOrderRequests <- (map["repair_order_requests"], ArrayTransform<RepairOrder>())
        createdAt <- (map["created_at"], VLISODateTransform())
        updatedAt <- (map["updated_at"], VLISODateTransform())
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
    func getState() -> State {
        return State(rawValue: state)!
    }
    
    func hasUpcomingRequestToday() -> Bool {
        if let pickupRequest = pickupRequest {
            if pickupRequest.getState() == .requested || pickupRequest.getState() == .started {
                if pickupRequest.isToday() {
                    return true
                }
            }
        }
        if let dropOffRequest = dropoffRequest {
            if dropOffRequest.getState() == .requested || dropOffRequest.getState() == .started {
                if dropOffRequest.isToday() {
                    return true
                }
            }
        }
        return false
    }
    
    func getRepairOrderName() -> String {
        if repairOrderRequests.count > 0 {
            var name = ""
            name.append(repairOrderRequests[0].getTitle())
            if repairOrderRequests.count > 1 {
                for i in 1...repairOrderRequests.count - 1 {
                    name.append(" | \(repairOrderRequests[i].getTitle())")
                }
            }
            return name
        }
        return ""
    }
    
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
                    refreshTime = Booking.defaultRefresh
                }
            }
        }
        
        return refreshTime
    }
    
    // returns distanceFromDestination in meters, nil if not applicable
    private func distanceFromDestination(request: Request) -> Double? {
        
        if let driver = request.driver, let location = driver.location, let coordinates = location.getLocation(),
            let requestLocation = request.location, let requestCoordinates = requestLocation.getLocation() {
            return Location.distanceBetweenLocations(from: coordinates, to: requestCoordinates)
        }
        return nil
    }
    
    // returns distanceFromOrigin in meters, nil if not applicable
    private func distanceFromOrigin(request: Request, dealership: Dealership) -> Double? {
        if let driver = request.driver, let location = driver.location, let coordinates = location.getLocation(),
            let dealershipLocation = dealership.location, let dealershipCoordinates = dealershipLocation.getLocation() {
            return Location.distanceBetweenLocations(from: coordinates, to: dealershipCoordinates)
        }
        return nil
    }
    
    public static func getStateForBooking(booking: Booking?) -> ServiceState {
        if let booking = booking {
            return ServiceState.appStateForBookingState(bookingState: booking.getState())
        }
        return .idle
    }
    
    public func isActive() -> Bool {
        let state = getState()
        if hasUpcomingRequestToday() || (state == .service || state == .serviceCompleted
            || state == .enRouteForDropoff || state == .enRouteForPickup
            || state == .nearbyForDropoff || state == .nearbyForPickup
            || state == .arrivedForDropoff || state == .arrivedForPickup) {
            return true
        } else if state == .dropoffScheduled {
            if let dropoffRequest = self.dropoffRequest, let type = dropoffRequest.getType(), type == .advisorDropoff {
                return true
            }
        }
        return false
    }
    
    public func needsRating() -> Bool {
        return self.bookingFeedbackId > 0 && (self.bookingFeedback == nil || self.bookingFeedback!.needsRating())
    }
    
    public func isSelfIB() -> Bool {
        if let pickupRequest = self.pickupRequest, let type = pickupRequest.getType() {
            return type == .advisorPickup
        }
        return false
    }
    
    public func isSelfOB() -> Bool {
        if let dropoffRequest = self.dropoffRequest, let type = dropoffRequest.getType() {
            return type == .advisorDropoff
        }
        return false
    }
    
    public func getCurrentRequestType() -> RequestType? {
        if let dropoffRequest = self.dropoffRequest, let type = dropoffRequest.getType() {
            return type
        } else if let pickupRequest = self.pickupRequest, let type = pickupRequest.getType() {
            return type
        } else {
            return nil
        }
    }
    
    public func getLastCompletedRequest() -> Request? {
        if let dropoffRequest = self.dropoffRequest, dropoffRequest.getState() == .completed {
            return dropoffRequest
        } else if let pickupRequest = self.pickupRequest, pickupRequest.getState() == .completed {
            return pickupRequest
        }
        return nil
    }
    
}
