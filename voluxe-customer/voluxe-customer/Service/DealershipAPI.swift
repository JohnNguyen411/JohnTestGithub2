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
        
        NetworkRequest.request(url: "/v1/dealerships", queryParameters: [:], withBearer: true).responseJSON { response in
            
            var responseObject: ResponseObject<MappableDataArray<Dealership>>?
            
            if let json = response.result.value as? [String: Any] {
                Logger.print("JSON: \(json)")
                responseObject = ResponseObject<MappableDataArray<Dealership>>(json: json)
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
     Get a list of Dealership near Location
     - parameter location: the location

     - Returns: A Future ResponseObject containing a list of Dealership around the location, or an AFError if an error occured
     */
    func getDealerships(location: CLLocationCoordinate2D) -> Future<ResponseObject<MappableDataArray<Dealership>>?, AFError> {
        let promise = Promise<ResponseObject<MappableDataArray<Dealership>>?, AFError>()
        
        NetworkRequest.request(url: "/v1/dealerships/near", queryParameters: ["latitude": "\(location.latitude)", "longitude" : "\(location.longitude)"], withBearer: true).responseJSON { response in
            
            var responseObject: ResponseObject<MappableDataArray<Dealership>>?
            
            if let json = response.result.value as? [String: Any] {
                Logger.print("JSON: \(json)")
                responseObject = ResponseObject<MappableDataArray<Dealership>>(json: json)
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
