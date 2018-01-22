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
     
     - Returns: A Future ResponseObject containing a Booking, or an AFError if an error occured
     */
    func createBooking(customerId: Int, vehicleId: Int, dealershipId: Int, loaner: Bool) -> Future<ResponseObject<MappableDataObject<Booking>>?, AFError> {
        let promise = Promise<ResponseObject<MappableDataObject<Booking>>?, AFError>()
        let params: Parameters = [
            "customer_id": customerId,
            "vehicle_id": vehicleId,
            "dealership_id": dealershipId,
            "loaner_vehicle_requested": loaner,
        ]
        
        NetworkRequest.request(url: "/v1/bookings", queryParameters: nil, bodyParameters: params, withBearer: true).responseJSON { response in
            
            var responseObject: ResponseObject<MappableDataObject<Booking>>?
            
            if let json = response.result.value as? [String: Any] {
                Logger.print("JSON: \(json)")
                responseObject = ResponseObject<MappableDataObject<Booking>>(json: json)
            }
            
            if response.error == nil {
                promise.success(responseObject)
            } else {
                promise.failure(response.error as! AFError)
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
    func getBooking(customerId: Int, bookingId: Int) -> Future<ResponseObject<MappableDataObject<Booking>>?, AFError> {
        let promise = Promise<ResponseObject<MappableDataObject<Booking>>?, AFError>()

        NetworkRequest.request(url: "/v1/customers/\(customerId)/bookings/\(bookingId)", queryParameters: nil, withBearer: true).responseJSON { response in
            
            var responseObject: ResponseObject<MappableDataObject<Booking>>?
            
            if let json = response.result.value as? [String: Any] {
                Logger.print("JSON: \(json)")
                responseObject = ResponseObject<MappableDataObject<Booking>>(json: json)
            }
            
            if response.error == nil {
                promise.success(responseObject)
            } else {
                promise.failure(response.error as! AFError)
            }
        }
        return promise.future
    }
    
    /**
     Get the bookings of a customer
     - parameter customerId: Customer's Id
     
     - Returns: A Future ResponseObject containing a list of Bookings, or an AFError if an error occured
     */
    func getBookings(customerId: Int) -> Future<ResponseObject<MappableDataArray<Booking>>?, AFError> {
        let promise = Promise<ResponseObject<MappableDataArray<Booking>>?, AFError>()
        
        NetworkRequest.request(url: "/v1/customers/\(customerId)/bookings", queryParameters: nil, withBearer: true).responseJSON { response in
                
                var responseObject: ResponseObject<MappableDataArray<Booking>>?
                
                if let json = response.result.value as? [String: Any] {
                    Logger.print("JSON: \(json)")
                    responseObject = ResponseObject<MappableDataArray<Booking>>(json: json)
                }
                
                if response.error == nil {
                    promise.success(responseObject)
                } else {
                    promise.failure(response.error as! AFError)
                }
        }
        return promise.future
    }
    
    /**
     Create a Pickup Request
     - parameter bookingId: The booking ID related to the pickup
     - parameter timeSlotId: The TimeSlot ID Choosed by the customer for the pickup
     - parameter location: The location choosed by the customer for the pickup
     
     - Returns: A Future ResponseObject containing the Pickup, or an AFError if an error occured
     */
    func createPickupRequest(bookingId: Int, timeSlotId: Int, location: Location) -> Future<ResponseObject<MappableDataObject<Request>>?, AFError> {
        let promise = Promise<ResponseObject<MappableDataObject<Request>>?, AFError>()

        let params: Parameters = [
            "booking_id": bookingId,
            "dealership_time_slot_id": timeSlotId, 
            "state": "created",
            "location": location.toJSON()
            ]
        
        NetworkRequest.request(url: "/v1/driver-pickup-requests", queryParameters: nil, bodyParameters: params, withBearer: true).responseJSON { response in
            
            var responseObject: ResponseObject<MappableDataObject<Request>>?
            
            if let json = response.result.value as? [String: Any] {
                Logger.print("JSON: \(json)")
                responseObject = ResponseObject<MappableDataObject<Request>>(json: json)
            }
            
            if response.error == nil {
                promise.success(responseObject)
            } else {
                promise.failure(response.error as! AFError)
            }
        }
        return promise.future
    }
    
}
