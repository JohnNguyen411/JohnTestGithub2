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

/// 🚲 A two-wheeled, human-powered mode of transportation.
class BookingAPI: NSObject {
    
    /**
     Create Booking for Customer
     - parameters:
     - customerId: Customer's Id
     - vehicleId: Customer's vehicle that needs to be serviced
     - dealershipId: Dealership choosed by the Customer
     - loaner: If the customer requested a Loaner
     
     - Returns: A Future ResponseObject containing a Booking, or an AFError if an error occured
     */
    func createBooking(customerId: String, vehicleId: String, dealershipId: String, loaner: Bool) -> Future<ResponseObject<MappableDataObject<Booking>>?, AFError> {
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
     - parameters:
     - customerId: Customer's Id
     - bookingId: The Booking ID
     
     - Returns: A Future ResponseObject containing a Booking, or an AFError if an error occured
     */
    func getBooking(customerId: Int, bookingId: Int) -> Future<ResponseObject<MappableDataObject<Booking>>?, AFError> {
        let promise = Promise<ResponseObject<MappableDataObject<Booking>>?, AFError>()

        NetworkRequest.request(url: NetworkRequest.replaceValues(url: "/v1/customers/\(customerId)/bookings/\(bookingId)",
            values: ["\(customerId)", "\(bookingId)"]), queryParameters: nil, withBearer: true).responseJSON { response in
            
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
     - parameters:
     - customerId: Customer's Id
     
     - Returns: A Future ResponseObject containing a list of Bookings, or an AFError if an error occured
     */
    func getBookings(customerId: Int) -> Future<ResponseObject<MappableDataArray<Booking>>?, AFError> {
        let promise = Promise<ResponseObject<MappableDataArray<Booking>>?, AFError>()
        
        NetworkRequest.request(url: NetworkRequest.replaceValues(url: "/v1/customers/\(customerId)/bookings", queryParameters: nil, withBearer: true).responseJSON { response in
                
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
    
}
