//
//  Booking.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 1/16/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

@objcMembers public class Booking: NSObject, Codable {
    
    public static let distanceTrigger = 500.0 // refresh more ofter when within 500m from origin or destination
    
    public static let refreshEnRouteClose = 10
    public static let refreshEnRoute = 20
    
    public dynamic var id: Int = -1
    public dynamic var customerId: Int = -1
    public dynamic var customer: Customer?
    public dynamic var state: String = "created"
    public dynamic var vehicleId: Int = -1
    public dynamic var vehicle: Vehicle?
    public dynamic var dealershipId: Int = -1
    public dynamic var dealership: Dealership?
    public dynamic var loanerVehicleRequested: Bool = false
    public dynamic var loanerVehicleId: Int = -1
    public dynamic var loanerVehicle: Vehicle?
    public dynamic var pickupRequest: Request?
    public dynamic var pickupRequestId: Int = -1
    public dynamic var dropoffRequest: Request?
    public dynamic var dropoffRequestId: Int = -1
    public dynamic var bookingFeedbackId: Int = -1
    public dynamic var bookingFeedback: BookingFeedback?
    public dynamic var repairOrderRequests: [RepairOrder] = []
    public dynamic var createdAt: Date?
    public dynamic var updatedAt: Date?

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
        case loanerVehicle = "loaner_vehicle"
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
    
    convenience required public init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        self.customer = try container.decodeIfPresent(Customer.self, forKey: .customer)
        self.state = try container.decode(String.self, forKey: .state)
        self.vehicleId = try container.decode(Int.self, forKey: .vehicleId)
        self.vehicle = try container.decodeIfPresent(Vehicle.self, forKey: .vehicle)
        self.dealershipId = try container.decode(Int.self, forKey: .dealershipId)
        self.dealership = try container.decodeIfPresent(Dealership.self, forKey: .dealership)
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
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(customer, forKey: .customer)
        try container.encode(state, forKey: .state)
        try container.encode(vehicleId, forKey: .vehicleId)
        try container.encodeIfPresent(vehicle, forKey: .vehicle)
        try container.encode(dealershipId, forKey: .dealershipId)
        try container.encodeIfPresent(dealership, forKey: .dealership)
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
    
    public func getState() -> State {
        return State(rawValue: state)!
    }
    
    
    public func hasUpcomingRequestToday() -> Bool {
        if let pickupRequest = pickupRequest {
            if pickupRequest.state == .requested || pickupRequest.state == .started {
                if pickupRequest.isToday() {
                    return true
                }
            }
        }
        if let dropOffRequest = dropoffRequest {
            if dropOffRequest.state == .requested || dropOffRequest.state == .started {
                if dropOffRequest.isToday() {
                    return true
                }
            }
        }
        return false
    }
    
    
    // Repair Orders methods:
    
    public func repairOrderIds() -> String {
        var rosID = ""
        for ro in self.repairOrderRequests {
            if let roID = ro.repairOrderId {
                rosID.append("\(roID),")
            }
        }
        if rosID.count > 0 {
            rosID.removeLast()
        }
        return rosID
    }
    
    public func getRepairOrderName() -> String {
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
    
    // returns distanceFromDestination in meters, nil if not applicable
    public func distanceFromDestination(request: Request) -> Double? {
        
        if let driver = request.driver, let location = driver.location, let coordinates = location.getLocation(),
            let requestLocation = request.location, let requestCoordinates = requestLocation.getLocation() {
            return Location.distanceBetweenLocations(from: coordinates, to: requestCoordinates)
        }
        return nil
    }
    
    // returns distanceFromOrigin in meters, nil if not applicable
    public func distanceFromOrigin(request: Request, dealership: Dealership) -> Double? {
        if let driver = request.driver, let location = driver.location, let coordinates = location.getLocation(),
            let dealershipLocation = dealership.location, let dealershipCoordinates = dealershipLocation.getLocation() {
            return Location.distanceBetweenLocations(from: coordinates, to: dealershipCoordinates)
        }
        return nil
    }
    
    public func isActive() -> Bool {
        let state = getState()
        if hasUpcomingRequestToday() || (state == .service || state == .serviceCompleted
            || state == .enRouteForDropoff || state == .enRouteForPickup
            || state == .nearbyForDropoff || state == .nearbyForPickup
            || state == .arrivedForDropoff || state == .arrivedForPickup) {
            return true
        } else if state == .pickupScheduled {
            if let pickupRequest = self.pickupRequest, let type = pickupRequest.type, type == .advisorPickup {
                return true
            }
        } else if state == .dropoffScheduled {
            if let dropoffRequest = self.dropoffRequest, let type = dropoffRequest.type, type == .advisorDropoff {
                return true
            }
        }
        return false
    }
    
    public func needsRating() -> Bool {
        return self.bookingFeedbackId > 0 && (self.bookingFeedback == nil || self.bookingFeedback!.needsRating())
    }
    
    public func isSelfIB() -> Bool {
        if let pickupRequest = self.pickupRequest, let type = pickupRequest.type {
            return type == .advisorPickup
        }
        return false
    }
    
    public func isSelfOB() -> Bool {
        if let dropoffRequest = self.dropoffRequest, let type = dropoffRequest.type {
            return type == .advisorDropoff
        }
        return false
    }
    
    public func getCurrentRequestType() -> Type? {
        if let dropoffRequest = self.dropoffRequest, let type = dropoffRequest.type {
            return type
        } else if let pickupRequest = self.pickupRequest, let type = pickupRequest.type {
            return type
        } else {
            return nil
        }
    }
    
    public func getLastCompletedRequest() -> Request? {
        if let dropoffRequest = self.dropoffRequest, dropoffRequest.state == .completed {
            return dropoffRequest
        } else if let pickupRequest = self.pickupRequest, pickupRequest.state == .completed {
            return pickupRequest
        }
        return nil
    }
    
}
