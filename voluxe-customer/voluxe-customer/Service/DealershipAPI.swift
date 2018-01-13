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

class DealershipAPI: NSObject {
    
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
