//
//  Booking.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 1/16/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import CoreLocation
import RealmSwift
import Realm

@objcMembers class Booking: Object, Codable {
    
    private static let distanceTrigger = 500.0 // refresh more ofter when within 500m from origin or destination
    
    private static let refreshEnRouteClose = 10
    private static let refreshEnRoute = 20
    
    dynamic var id: Int = -1
    dynamic var customerId: Int = -1
    dynamic var customer: Customer?
    dynamic var state: String = "created"
    dynamic var vehicleId: Int = -1
    dynamic var vehicle: Vehicle?
    dynamic var dealershipId: Int = -1
    dynamic var dealership: Dealership?
    dynamic var loanerVehicleRequested: Bool = false
    dynamic var loanerVehicleId: Int = -1
    dynamic var loanerVehicle: Vehicle?
    dynamic var pickupRequest: Request?
    dynamic var pickupRequestId: Int = -1
    dynamic var dropoffRequest: Request?
    dynamic var dropoffRequestId: Int = -1
    dynamic var bookingFeedbackId: Int = -1
    dynamic var bookingFeedback: BookingFeedback?
    dynamic var repairOrderRequests = List<RepairOrder>()
    dynamic var createdAt: Date?
    dynamic var updatedAt: Date?

    private enum CodingKeys: String, CodingKey {
        case id
        case customerId = "customer_id"
        case customer
        case state
        case vehicleId = "vehicle_id"
        case vehicle
        case dealershipId = "dealership_id"
        case dealership
        case loanerVehicleRequested = "loaner_vehicle_requested"
        case loanerVehicleId = "loaner_vehicle_id"
        case loanerVehicle
        case pickupRequest = "pickup_request"
        case pickupRequestId = "pickup_request_id"
        case dropoffRequest = "dropoff_request"
        case dropoffRequestId = "dropoff_request_id"
        case bookingFeedbackId = "booking_feedback_id"
        case repairOrderRequests = "repair_order_requests"
        case createdAt = "created_at" //TODO: VLISODateTransform?
        case updatedAt = "updated_at" //TODO: VLISODateTransform?
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
                    refreshTime = Config.sharedInstance.bookingRefresh()
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
        } else if state == .pickupScheduled {
            if let pickupRequest = self.pickupRequest, let type = pickupRequest.getType(), type == .advisorPickup {
                return true
            }
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
