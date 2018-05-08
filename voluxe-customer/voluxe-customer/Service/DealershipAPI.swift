//
//  DealershipAPI.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 12/7/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import BrightFutures
import CoreLocation

/// Class regrouping all the methods creating requests to handle Dealership
class DealershipAPI: NSObject {
    
    /**
     Get a list of Dealership
     
     - Returns: A Future ResponseObject containing a list of Dealership, or an AFError if an error occured
     */
    func getDealerships() -> Future<ResponseObject<MappableDataArray<Dealership>>?, AFError> {
        let promise = Promise<ResponseObject<MappableDataArray<Dealership>>?, AFError>()
        
        NetworkRequest.request(url: "/v1/dealerships", queryParameters: [:], withBearer: true).responseJSONErrorCheck { response in
            var responseObject: ResponseObject<MappableDataArray<Dealership>>?
            
            if let json = response.result.value as? [String: Any] {
                responseObject = ResponseObject<MappableDataArray<Dealership>>(json: json)
            }
            
            if response.error == nil {
                promise.success(responseObject)
            } else {
                promise.failure(Errors.safeAFError(error: response.error!))
            }
        }
        return promise.future
    }
    
    
    /**
     Get a list of Dealership near Location
     - parameter location: the location

     - Returns: A Future ResponseObject containing a list of Dealership around the location, or an AFError if an error occured
     */
    func getDealerships(location: CLLocationCoordinate2D) -> Future<ResponseObject<MappableDataArray<Dealership>>?, AFError> {
        let promise = Promise<ResponseObject<MappableDataArray<Dealership>>?, AFError>()
        
        NetworkRequest.request(url: "/v1/dealerships/near", queryParameters: ["latitude": "\(location.latitude)", "longitude" : "\(location.longitude)"], withBearer: true).responseJSONErrorCheck { response in
            var responseObject: ResponseObject<MappableDataArray<Dealership>>?
            
            if let json = response.result.value as? [String: Any] {
                responseObject = ResponseObject<MappableDataArray<Dealership>>(json: json)
            }
            
            if response.error == nil {
                promise.success(responseObject)
            } else {
                promise.failure(Errors.safeAFError(error: response.error!))
            }
        }
        return promise.future
    }
    
    /**
     Get a list of Time slot for a dealership
     - parameter dealershipId: the dealership_id
     - parameter type: the type of TimeSlot (driver, advisor). `driver` for Pickup/Delivery, `advisor` for "self" IB/OB
     - parameter loaner: true if loaner is requested, false otherwise
     - parameter from: the dealership_id
     - parameter to: the dealership_id

     - Returns: A Future ResponseObject containing a list of Time Slot available for a dealership, or an AFError if an error occured
     */
    func getDealershipTimeSlot(dealershipId: Int, type: String, loaner: Bool, from: String, to: String) -> Future<ResponseObject<MappableDataArray<DealershipTimeSlot>>?, AFError> {
        let promise = Promise<ResponseObject<MappableDataArray<DealershipTimeSlot>>?, AFError>()
        
        // "loaner": loaner,
        let queryParams = [
            "type": type,
            "from": from,
            "to": to,
            ] as [String : Any]
        
        NetworkRequest.request(url: "/v1/dealerships/\(dealershipId)/time-slots/scheduled", queryParameters: queryParams, withBearer: true).responseJSONErrorCheck { response in
            var responseObject: ResponseObject<MappableDataArray<DealershipTimeSlot>>?
            
            if let json = response.result.value as? [String: Any] {
                responseObject = ResponseObject<MappableDataArray<DealershipTimeSlot>>(json: json)
            }
            
            if response.error == nil {
                promise.success(responseObject)
            } else {
                promise.failure(Errors.safeAFError(error: response.error!))
            }
        }
        return promise.future
    }
    
}
