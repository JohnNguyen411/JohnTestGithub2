//
//  CustomerAPI+Bookings.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 11/9/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

extension CustomerAPI {

    
    /**
     Create Booking for Customer
     - parameter customerId: Customer's Id
     - parameter vehicleId: Customer's vehicle that needs to be serviced
     - parameter dealershipId: Dealership choosed by the Customer
     - parameter loaner: If the customer requested a Loaner
     - parameter dealershipRepairId: The dealership repairOrderId, or nil if repair_order created separately
     - parameter repairNotes: The repair_order notes, or nil if repair_order created separately
     - parameter repairTitle: The repair_order title, or nil if repair_order created separately
     - parameter vehicleDrivable: The repair_order vehicle_drivable, or nil if repair_order created separately
     - parameter completion: A closure which is called with a Booking Object or APIResponseError if an error occured
     */
    static func createBooking(customerId: Int, vehicleId: Int, dealershipId: Int, loaner: Bool, dealershipRepairId: Int?, repairNotes: String?, repairTitle: String?, vehicleDrivable: Bool?, timeSlotId: Int?, location: Location?, isDriver: Bool,
                       completion: @escaping ((Booking?, APIResponseError?) -> Void)) {

        var pickupParams: [String: Any] = ["type": isDriver ? "driver_pickup" : "advisor_pickup"]
        
        if let timeslotId = timeSlotId, let location = location {
            pickupParams["dealership_time_slot_id"] = "\(timeslotId)"
            pickupParams["location"] = location.toJSON()
        }
        
        var params: [String: Any] = [
            "vehicle_id": "\(vehicleId)",
            "dealership_id": "\(dealershipId)",
            "loaner_vehicle_requested": "\(loaner)",
            "pickup_request": "\(pickupParams)"
        ]
        
        if let dealershipRepairId = dealershipRepairId {
            var repairOrder = [
                "dealership_repair_order_id": "\(dealershipRepairId)"
            ]
            if let notes = repairNotes {
                repairOrder["notes"] = "\(notes)"
            }
            if let vehicleDrivable = vehicleDrivable {
                repairOrder["vehicle_drivable"] = "\(vehicleDrivable)"
            }
            if let repairTitle = repairTitle {
                repairOrder["title"] = "\(repairTitle)"
            }
            params["repair_order_requests"] = [repairOrder]
        }
        
        
        self.api.post(route: "v1/customers/\(customerId)/bookings", bodyParameters: params) {
            response in
            let booking = response?.decodeBooking()
            completion(booking, response?.asError())
        }
    }
    
    /**
     Get Booking with CustomerID and BookingID
     - parameter customerId: Customer's Id
     - parameter bookingId: The Booking ID
     - parameter completion: A closure which is called with a Booking Object or APIResponseError if an error occured
     */
    static func booking(customerId: Int, bookingId: Int,
                        completion: @escaping ((Booking?, APIResponseError?) -> Void)) {
        
        self.api.get(route: "v1/customers/\(customerId)/bookings/\(bookingId)") {
            response in
            let booking = response?.decodeBooking()
            completion(booking, response?.asError())
        }
        
    }
    
    /**
     Get Booking with CustomerID and BookingID
     - parameter customerId: Customer's Id
     - parameter bookingId: The Booking ID
     - parameter completion: A closure which is called with a Booking array or APIResponseError if an error occured
     */
    static func bookings(customerId: Int, active: Bool?, sort: String? = nil,
                        completion: @escaping (([Booking], APIResponseError?) -> Void)) {
        
        var params: [String: String] = [:]
        if let active = active {
            params["active"] = active ? "true" : "false"
        }
        if let sort = sort {
            params["sort[0]"] = sort
        }
        
        self.api.get(route: "v1/customers/\(customerId)/bookings/") {
            response in
            let bookings = response?.decodeBookings() ?? []
            completion(bookings, response?.asError())
        }
    }
    
    /**
     Create a Pickup Request
     - parameter bookingId: The booking ID related to the pickup
     - parameter timeSlotId: The TimeSlot ID Choosed by the customer for the pickup
     - parameter location: The location choosed by the customer for the pickup
     - parameter isDriver: true if the request type if driver, false if advisor
     - parameter completion: A closure which is called with a Request Object or APIResponseError if an error occured
     */
    static func createPickupRequest(customerId: Int, bookingId: Int, timeSlotId: Int?, location: Location, isDriver: Bool,
                                     completion: @escaping ((Request?, APIResponseError?) -> Void)) {
        
        let params: [String : Any] = [
            "dealership_time_slot_id": timeSlotId ?? "",
            "location": location.toJSON(),
            "type": isDriver ? "driver_pickup" : "advisor_pickup"
            ]
        
        self.api.put(route: "v1/customers/\(customerId)/bookings/\(bookingId)/pickup-request", bodyParameters: params) {
            response in
            let request = response?.decodeRequest()
            completion(request, response?.asError())
        }
    }
    
    /**
     Create a DropOff Request
     - parameter bookingId: The booking ID related to the pickup
     - parameter timeSlotId: The TimeSlot ID Choosed by the customer for the pickup
     - parameter location: The location choosed by the customer for the pickup
     - parameter isDriver: true if the request type if driver, false if advisor
     - parameter completion: A closure which is called with a Request Object or APIResponseError if an error occured
     */
    static func createDropoffRequest(customerId: Int, bookingId: Int, timeSlotId: Int?, location: Location, isDriver: Bool,
                              completion: @escaping ((Request?, APIResponseError?) -> Void)) {
        
        var params: [String: Any] = [:]
        
        if let timeSlot = timeSlotId {
            params = [
                "dealership_time_slot_id": "\(timeSlot)",
                "location": location.toJSON()
            ]
        }
        
        params["type"] = isDriver ? "driver_dropoff" : "advisor_dropoff"
        
        
        self.api.put(route: "v1/customers/\(customerId)/bookings/\(bookingId)/dropoff-request", bodyParameters: params) {
            response in
            let request = response?.decodeRequest()
            completion(request, response?.asError())
        }
    }
    
    /**
     Cancel a Pickup Request
     - parameter customerId: The customer ID
     - parameter bookingId: The booking ID to cancel
     - parameter requestId: The request ID to cancel
     - parameter completion: A closure which is called with an error if occured
     */
    static func cancelPickupRequest(customerId: Int, bookingId : Int, requestId: Int, isDriver: Bool,
                                     completion: @escaping ((APIResponseError?) -> Void)) {
        
        var endpoint = "driver-pickup-requests"
        if !isDriver {
            endpoint = "advisor-pickup-requests"
        }
        
        self.api.put(route: "v1/customers/\(customerId)/bookings/\(bookingId)/\(endpoint)/\(requestId)/cancel") {
            response in
            completion(response?.asError())
        }
    }
    
    /**
     Cancel a Dropoff Request
     - parameter customerId: The customer ID
     - parameter bookingId: The booking ID to cancel
     - parameter requestId: The request ID to cancel
     
     - Returns: A Future EmptyMappableObject, or an AFError if an error occured
     */
    static func cancelDropoffRequest(customerId: Int, bookingId : Int, requestId: Int, isDriver: Bool,
                                    completion: @escaping ((APIResponseError?) -> Void)) {
        
        var endpoint = "driver-dropoff-requests"
        if !isDriver {
            endpoint = "advisor-dropoff-requests"
        }
        
        self.api.put(route: "v1/customers/\(customerId)/bookings/\(bookingId)/\(endpoint)/\(requestId)/cancel") {
            response in
            completion(response?.asError())
        }
    }
    
    
    
}

fileprivate extension RestAPIResponse {
    
    private struct RequestResponse: Codable {
        let data: Request
    }
    
    func decodeRequest() -> Request? {
        let request: RequestResponse? = self.decode()
        return request?.data
    }
    
    private struct BookingResponse: Codable {
        let data: Booking
    }
    
    func decodeBooking() -> Booking? {
        let booking: BookingResponse? = self.decode()
        return booking?.data
    }
    
    private struct BookingsResponse: Codable {
        let data: [Booking]
    }
    
    func decodeBookings() -> [Booking]? {
        let bookingsResponse: BookingsResponse? = self.decode()
        return bookingsResponse?.data
    }
    
    private struct BookingsResponse: Codable {
        let data: [Booking]
    }
    
}
