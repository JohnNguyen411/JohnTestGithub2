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
            name.append(repairOrderRequests[0].name ?? "")
            if repairOrderRequests.count > 1 {
                for i in 0...repairOrderRequests.count {
                    name.append("| \(repairOrderRequests[i].name ?? "")")
                }
            }
            return name
        }
        return ""
    }
    
    public func getRefreshTime() -> Int {
        if pickupRequest != nil || dropoffRequest != nil {
            if getState() != .serviceCompleted && getState() != .completed && getState() != .canceled {
                if let pickupRequest = pickupRequest, let dealership = dealership, (getState() == .enRouteForPickup || getState() == .nearbyForPickup) {
                    let distanceFromDestination = self.distanceFromDestination(request: pickupRequest)
                    let distanceFromOrigin = self.distanceFromOrigin(request: pickupRequest, dealership: dealership)
                    // if driver is close to dealership or destination
                    if let distanceFromDestination = distanceFromDestination, let distanceFromOrigin = distanceFromOrigin,
                        distanceFromDestination < Booking.distanceTrigger || distanceFromOrigin < Booking.distanceTrigger {
                        return Booking.refreshEnRouteClose
                    } else {
                        return Booking.refreshEnRoute
                    }
                } else if let dropoffRequest = dropoffRequest, let dealership = dealership, (getState() == .enRouteForDropoff || getState() == .nearbyForDropoff) {
                    let distanceFromDestination = self.distanceFromDestination(request: dropoffRequest)
                    let distanceFromOrigin = self.distanceFromOrigin(request: dropoffRequest, dealership: dealership)
                    // if driver is close to dealership or destination
                    if let distanceFromDestination = distanceFromDestination, let distanceFromOrigin = distanceFromOrigin,
                        distanceFromDestination < Booking.distanceTrigger || distanceFromOrigin < Booking.distanceTrigger {
                        return Booking.refreshEnRouteClose
                    } else {
                        return Booking.refreshEnRoute
                    }
                    
                } else {
                    return Booking.defaultRefresh
                }
            }
        }
        return 0
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
    
    
    
    static func mockBooking(customer: Customer, vehicle: Vehicle, dealership: Dealership) -> Booking {
        let booking = Booking()
        booking.id = Int(arc4random_uniform(99999)) + 1
        booking.customer = customer
        booking.customerId = customer.id
        booking.vehicle = vehicle
        booking.vehicleId = vehicle.id
        booking.dealershipId = dealership.id
        booking.dealership = dealership
        return booking
    }
}
