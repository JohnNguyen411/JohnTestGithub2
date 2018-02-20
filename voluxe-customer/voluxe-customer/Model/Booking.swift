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

class Booking: Object, Mappable {
    
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
    @objc dynamic var repairOrderRequests: RepairOrder?
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
        repairOrderRequests <- map["repair_order_requests"]
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
            if pickupRequest.getState() == .created {
                if pickupRequest.isToday() {
                    return true
                }
            }
        }
        if let dropOffRequest = pickupRequest {
            if dropOffRequest.getState() == .created {
                if dropOffRequest.isToday() {
                    return true
                }
            }
        }
        return false
    }
    
    public static func getStateForBooking(booking: Booking?) -> ServiceState {
        if let booking = booking {
            if booking.dropoffRequest != nil {
                return .deliveryScheduled
            } else if (booking.pickupRequest != nil) {
                return .pickupScheduled
            }
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
