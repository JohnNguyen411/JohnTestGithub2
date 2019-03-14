//
//  Booking.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 1/16/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

@objcMembers class Booking: NSObject, Codable {
    
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
    dynamic var repairOrderRequests: [RepairOrder] = []
    dynamic var createdAt: Date?
    dynamic var updatedAt: Date?

    private enum CodingKeys: String, CodingKey {
        case id
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
        case bookingFeedback = "booking_feedback"
        case bookingFeedbackId = "booking_feedback_id"
        case repairOrderRequests = "repair_order_requests"
        case createdAt = "created_at" 
        case updatedAt = "updated_at" 
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        self.customer = try container.decodeIfPresent(Customer.self, forKey: .customer)
        self.state = try container.decode(String.self, forKey: .state)
        self.vehicleId = try container.decode(Int.self, forKey: .vehicleId)
        self.vehicle = try container.decodeIfPresent(Vehicle.self, forKey: .vehicle)
        self.dealershipId = try container.decode(Int.self, forKey: .dealershipId)
        self.dealership = try container.decode(Dealership.self, forKey: .dealership)
        self.loanerVehicleRequested = try container.decodeIfPresent(Bool.self, forKey: .loanerVehicleRequested) ?? false
        self.loanerVehicleId = try container.decodeIfPresent(Int.self, forKey: .loanerVehicleId) ?? -1
        self.loanerVehicle = try container.decodeIfPresent(Vehicle.self, forKey: .loanerVehicle)
        self.pickupRequest = try container.decodeIfPresent(Request.self, forKey: .pickupRequest)
        self.pickupRequestId = try container.decodeIfPresent(Int.self, forKey: .pickupRequestId) ?? -1
        self.dropoffRequest = try container.decodeIfPresent(Request.self, forKey: .dropoffRequest)
        self.dropoffRequestId = try container.decodeIfPresent(Int.self, forKey: .dropoffRequestId) ?? -1
        self.bookingFeedbackId = try container.decodeIfPresent(Int.self, forKey: .bookingFeedbackId) ?? -1
        self.bookingFeedback = try container.decodeIfPresent(BookingFeedback.self, forKey: .bookingFeedback)
        self.repairOrderRequests = try container.decodeIfPresent([RepairOrder].self, forKey: .repairOrderRequests) ?? []
        self.createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        self.updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(customer, forKey: .customer)
        try container.encode(state, forKey: .state)
        try container.encode(vehicleId, forKey: .vehicleId)
        try container.encodeIfPresent(vehicle, forKey: .vehicle)
        try container.encode(dealershipId, forKey: .dealershipId)
        try container.encode(dealership, forKey: .dealership)
        try container.encodeIfPresent(loanerVehicleRequested, forKey: .loanerVehicleRequested)
        try container.encodeIfPresent(loanerVehicleId, forKey: .loanerVehicleId)
        try container.encodeIfPresent(loanerVehicle, forKey: .loanerVehicle)
        try container.encodeIfPresent(pickupRequest, forKey: .pickupRequest)
        try container.encodeIfPresent(pickupRequestId, forKey: .pickupRequestId)
        try container.encodeIfPresent(dropoffRequest, forKey: .dropoffRequest)
        try container.encodeIfPresent(dropoffRequestId, forKey: .dropoffRequestId)
        try container.encodeIfPresent(bookingFeedbackId, forKey: .bookingFeedbackId)
        try container.encodeIfPresent(bookingFeedback, forKey: .bookingFeedback)
        try container.encodeIfPresent(repairOrderRequests, forKey: .repairOrderRequests)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(updatedAt, forKey: .updatedAt)
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
    
//TODO: Do Extension in Customer App
/*
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
 */
    
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
    
    //TODO: Do Extension in Customer App

    /*
    public static func getStateForBooking(booking: Booking?) -> ServiceState {
        if let booking = booking {
            return ServiceState.appStateForBookingState(bookingState: booking.getState())
        }
        return .idle
    }
 */
    
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
