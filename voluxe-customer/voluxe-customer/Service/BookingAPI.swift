//
//  BookingAPI.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 1/12/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import BrightFutures
import CoreLocation

/// Class regrouping all the methods creating the requests to handle Booking
class BookingAPI: NSObject {
    
    /**
     Create Booking for Customer
     - parameter customerId: Customer's Id
     - parameter vehicleId: Customer's vehicle that needs to be serviced
     - parameter dealershipId: Dealership choosed by the Customer
     - parameter loaner: If the customer requested a Loaner
     - parameter dealershipRepairId: The dealership repairOrderId, or nil if repair_order created separately
     - parameter repairNotes: The repair_order notes, or nil if repair_order created separately
     
     - Returns: A Future ResponseObject containing a Booking, or an AFError if an error occured
     */
    func createBooking(customerId: Int, vehicleId: Int, dealershipId: Int, loaner: Bool, dealershipRepairId: Int?, repairNotes: String?) -> Future<ResponseObject<MappableDataObject<Booking>>?, Errors> {
        let promise = Promise<ResponseObject<MappableDataObject<Booking>>?, Errors>()
        var params: Parameters = [
            "vehicle_id": vehicleId,
            "dealership_id": dealershipId,
            "loaner_vehicle_requested": loaner,
        ]
        
        if let dealershipRepairId = dealershipRepairId {
            var repairOrder: Parameters = [
                "dealership_repair_order_id": dealershipRepairId
            ]
            if let notes = repairNotes {
                repairOrder["notes"] = notes
            }
            params["repair_order_requests"] = [repairOrder]
        }
        
        
        NetworkRequest.request(url: "/v1/customers/\(customerId)/bookings", queryParameters: nil, bodyParameters: params, withBearer: true).responseJSONErrorCheck { response in
            
            let responseObject = ResponseObject<MappableDataObject<Booking>>(json: response.result.value, allowEmptyData: false)
            
            if response.error == nil && responseObject.error == nil {
                promise.success(responseObject)
            } else {
                promise.failure(Errors(dataResponse: response, apiError: responseObject.error))
            }
        }
        return promise.future
    }
    
    /**
     Get Booking with CustomerID and BookingID
     - parameter customerId: Customer's Id
     - parameter bookingId: The Booking ID
     
     - Returns: A Future ResponseObject containing a Booking, or an AFError if an error occured
     */
    func getBooking(customerId: Int, bookingId: Int) -> Future<ResponseObject<MappableDataObject<Booking>>?, Errors> {
        let promise = Promise<ResponseObject<MappableDataObject<Booking>>?, Errors>()

        NetworkRequest.request(url: "/v1/customers/\(customerId)/bookings/\(bookingId)", queryParameters: nil, withBearer: true).responseJSONErrorCheck { response in
            
            let responseObject = ResponseObject<MappableDataObject<Booking>>(json: response.result.value, allowEmptyData: false)
            
            if response.error == nil && responseObject.error == nil {
                promise.success(responseObject)
            } else {
                promise.failure(Errors(dataResponse: response, apiError: responseObject.error))
            }
            
        }
        return promise.future
    }
    
    /**
     Get the bookings of a customer
     - parameter customerId: Customer's Id
     - parameter active: true for active request only, false for non active, nil to ignore

     - Returns: A Future ResponseObject containing a list of Bookings, or an AFError if an error occured
     */
    func getBookings(customerId: Int, active: Bool?) -> Future<ResponseObject<MappableDataArray<Booking>>?, Errors> {
        let promise = Promise<ResponseObject<MappableDataArray<Booking>>?, Errors>()
        
        var params = ""
        if let active = active {
            params = "?active=\(active ? "true" : "false")"
        }
        
        NetworkRequest.request(url: "/v1/customers/\(customerId)/bookings\(params)", queryParameters: nil, withBearer: true).responseJSONErrorCheck { response in
            
            let responseObject = ResponseObject<MappableDataArray<Booking>>(json: response.result.value, allowEmptyData: false)
            
            if response.error == nil && responseObject.error == nil {
                promise.success(responseObject)
            } else {
                promise.failure(Errors(dataResponse: response, apiError: responseObject.error))
            }
    
        }
        return promise.future
    }
    
    /**
     Create a Pickup Request
     - parameter bookingId: The booking ID related to the pickup
     - parameter timeSlotId: The TimeSlot ID Choosed by the customer for the pickup
     - parameter location: The location choosed by the customer for the pickup
     - parameter isDriver: true if the request type if driver, false if advisor
     
     - Returns: A Future ResponseObject containing the Pickup, or an AFError if an error occured
     */
    func createPickupRequest(customerId: Int, bookingId: Int, timeSlotId: Int, location: Location, isDriver: Bool) -> Future<ResponseObject<MappableDataObject<Request>>?, Errors> {
        let promise = Promise<ResponseObject<MappableDataObject<Request>>?, Errors>()

        let params: Parameters = [
            "dealership_time_slot_id": timeSlotId,
            "location": location.toJSON()
            ]
        
        var endpoint = "driver-pickup-requests"
        if !isDriver {
            endpoint = "advisor-pickup-requests"
        }
        
        NetworkRequest.request(url: "/v1/customers/\(customerId)/bookings/\(bookingId)/\(endpoint)", queryParameters: nil, bodyParameters: params, withBearer: true).responseJSONErrorCheck { response in
            
            let responseObject = ResponseObject<MappableDataObject<Request>>(json: response.result.value, allowEmptyData: false)
            
            if response.error == nil && responseObject.error == nil {
                promise.success(responseObject)
            } else {
                promise.failure(Errors(dataResponse: response, apiError: responseObject.error))
            }
            
        }
        return promise.future
    }
    
    /**
     Create a DropOff Request
     - parameter bookingId: The booking ID related to the pickup
     - parameter timeSlotId: The TimeSlot ID Choosed by the customer for the pickup
     - parameter location: The location choosed by the customer for the pickup
     - parameter isDriver: true if the request type if driver, false if advisor
     
     - Returns: A Future ResponseObject containing the Pickup, or an AFError if an error occured
     */
    func createDropoffRequest(customerId: Int, bookingId: Int, timeSlotId: Int, location: Location, isDriver: Bool) -> Future<ResponseObject<MappableDataObject<Request>>?, Errors> {
        let promise = Promise<ResponseObject<MappableDataObject<Request>>?, Errors>()
        
        let params: Parameters = [
            "dealership_time_slot_id": timeSlotId,
            "location": location.toJSON()
        ]
        
        var endpoint = "driver-dropoff-requests"
        if !isDriver {
            endpoint = "advisor-dropoff-requests"
        }
        
        NetworkRequest.request(url: "/v1/customers/\(customerId)/bookings/\(bookingId)/\(endpoint)", queryParameters: nil, bodyParameters: params, withBearer: true).responseJSONErrorCheck { response in
            
            let responseObject = ResponseObject<MappableDataObject<Request>>(json: response.result.value, allowEmptyData: false)
            
            if response.error == nil && responseObject.error == nil {
                promise.success(responseObject)
            } else {
                promise.failure(Errors(dataResponse: response, apiError: responseObject.error))
            }
            
        }
        return promise.future
    }
    
    /**
     Cancel a Pickup Request
     - parameter customerId: The customer ID
     - parameter bookingId: The booking ID to cancel
     - parameter requestId: The request ID to cancel
     
     - Returns: A Future EmptyMappableObject, or an AFError if an error occured
     */
    func cancelPickupRequest(customerId: Int, bookingId : Int, requestId: Int, isDriver: Bool) -> Future<ResponseObject<EmptyMappableObject>?, Errors> {
        let promise = Promise<ResponseObject<EmptyMappableObject>?, Errors>()
        
        var endpoint = "driver-pickup-requests"
        if !isDriver {
            endpoint = "advisor-pickup-requests"
        }
        
        NetworkRequest.request(url: "/v1/customers/\(customerId)/bookings/\(bookingId)/\(endpoint)/\(requestId)/cancel", method: .put, queryParameters: nil, withBearer: true).responseJSONErrorCheck { response in
            
            let responseObject = ResponseObject<EmptyMappableObject>(json: response.result.value)
            
            if response.error == nil && responseObject.error == nil {
                promise.success(responseObject)
            } else {
                promise.failure(Errors(dataResponse: response, apiError: responseObject.error))
            }
        }
        return promise.future
    }
    
    /**
     Cancel a Dropoff Request
     - parameter customerId: The customer ID
     - parameter bookingId: The booking ID to cancel
     - parameter requestId: The request ID to cancel
     
     - Returns: A Future EmptyMappableObject, or an AFError if an error occured
     */
    func cancelDropoffRequest(customerId: Int, bookingId : Int, requestId: Int, isDriver: Bool) -> Future<ResponseObject<EmptyMappableObject>?, Errors> {
        let promise = Promise<ResponseObject<EmptyMappableObject>?, Errors>()
        
        var endpoint = "driver-dropoff-requests"
        if !isDriver {
            endpoint = "advisor-dropoff-requests"
        }
        
        NetworkRequest.request(url: "/v1/customers/\(customerId)/bookings/\(bookingId)/\(endpoint)/\(requestId)/cancel", method: .put, queryParameters: nil, withBearer: true).responseJSONErrorCheck { response in
            let responseObject = ResponseObject<EmptyMappableObject>(json: response.result.value)
            
            if response.error == nil && responseObject.error == nil {
                promise.success(responseObject)
            } else {
                promise.failure(Errors(dataResponse: response, apiError: responseObject.error))
            }
        }
        return promise.future
    }
    
    
    /**
     Contact Driver
     - parameter customerId: Customer's Id
     - parameter bookingId: The booking ID related to the pickup
     - parameter mode: The contact mode choosen: "text_only" or "voice_only"
     
     - Returns: A Future ResponseObject containing the ContactDriver object with text or voice phone number, or an AFError if an error occured
     */
    func contactDriver(customerId: Int, bookingId: Int, mode: String) -> Future<ResponseObject<MappableDataObject<ContactDriver>>?, Errors> {
        let promise = Promise<ResponseObject<MappableDataObject<ContactDriver>>?, Errors>()
        
        let params: Parameters = [
            "mode": mode
        ]
        
        NetworkRequest.request(url: "/v1/customers/\(customerId)/bookings/\(bookingId)/contact-driver", method: .put, queryParameters: nil, bodyParameters: params, withBearer: true).responseJSONErrorCheck { response in
            
            let responseObject = ResponseObject<MappableDataObject<ContactDriver>>(json: response.result.value, allowEmptyData: false)
            
            if response.error == nil && responseObject.error == nil {
                promise.success(responseObject)
            } else {
                promise.failure(Errors(dataResponse: response, apiError: responseObject.error))
            }
            
        }
        return promise.future
    }
    
    
    
}
