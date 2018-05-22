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
    func getDealerships() -> Future<ResponseObject<MappableDataArray<Dealership>>?, Errors> {
        let promise = Promise<ResponseObject<MappableDataArray<Dealership>>?, Errors>()
        
        NetworkRequest.request(url: "/v1/dealerships", queryParameters: [:], withBearer: true).responseJSONErrorCheck { response in
            
            let responseObject = ResponseObject<MappableDataArray<Dealership>>(json: response.result.value, allowEmptyData: false)
            
            if response.error == nil && responseObject.error == nil {
                promise.success(responseObject)
            } else {
                promise.failure(Errors(dataResponse: response, apiError: responseObject.error))
            }
            
        }
        return promise.future
    }
    
    
    /**
     Get a list of Dealership near Location
     - parameter location: the location

     - Returns: A Future ResponseObject containing a list of Dealership around the location, or an AFError if an error occured
     */
    func getDealerships(location: CLLocationCoordinate2D) -> Future<ResponseObject<MappableDataArray<Dealership>>?, Errors> {
        let promise = Promise<ResponseObject<MappableDataArray<Dealership>>?, Errors>()
        
        NetworkRequest.request(url: "/v1/dealerships/near", queryParameters: ["latitude": "\(location.latitude)", "longitude" : "\(location.longitude)"], withBearer: true).responseJSONErrorCheck { response in
            let responseObject = ResponseObject<MappableDataArray<Dealership>>(json: response.result.value, allowEmptyData: false)
            
            if response.error == nil && responseObject.error == nil {
                promise.success(responseObject)
            } else {
                promise.failure(Errors(dataResponse: response, apiError: responseObject.error))
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
    func getDealershipTimeSlot(dealershipId: Int, type: String, loaner: Bool, from: String, to: String) -> Future<ResponseObject<MappableDataArray<DealershipTimeSlot>>?, Errors> {
        let promise = Promise<ResponseObject<MappableDataArray<DealershipTimeSlot>>?, Errors>()
        
        // "loaner": loaner,
        let queryParams = [
            "type": type,
            "start": from,
            "end": to,
            "compute[0]": "available_loaner_vehicle_count", // request the loaner vehicle count in the response
            "compute[1]": "available_assignment_count", // request the number of available assignment for each slots
            ] as [String : Any]
        
        NetworkRequest.request(url: "/v1/dealerships/\(dealershipId)/time-slots/scheduled", queryParameters: queryParams, withBearer: true).responseJSONErrorCheck { response in
            
            let responseObject = ResponseObject<MappableDataArray<DealershipTimeSlot>>(json: response.result.value, allowEmptyData: false)
            
            if response.error == nil && responseObject.error == nil {
                promise.success(responseObject)
            } else {
                promise.failure(Errors(dataResponse: response, apiError: responseObject.error))
            }
            
        }
        return promise.future
    }
    
}
