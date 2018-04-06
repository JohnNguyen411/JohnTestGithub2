//
//  VehicleAPI.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 4/6/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import BrightFutures

class VehicleAPI: NSObject {
    
    /**
     Retrieve list of Makes available for Vehicles
     
     - Returns: A Future ResponseObject containing an Array of VehicleMake, or an AFError if an error occured
     */
    func vehicleMakes() -> Future<ResponseObject<MappableDataArray<VehicleMake>>?, AFError> {
        let promise = Promise<ResponseObject<MappableDataArray<VehicleMake>>?, AFError>()
        
        NetworkRequest.request(url: "/v1/vehicle-makes", queryParameters: nil, withBearer: false).responseJSON { response in
            
            
            var responseObject: ResponseObject<MappableDataArray<VehicleMake>>?
            
            if let json = response.result.value as? [String: Any] {
                responseObject = ResponseObject<MappableDataArray<VehicleMake>>(json: json)
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
     Retrieve list of Models available for Vehicles
     - parameter makeId: Make Id for the desired models (Optional)

     - Returns: A Future ResponseObject containing an Array of VehicleModel, or an AFError if an error occured
     */
    func vehicleModels(makeId: Int?) -> Future<ResponseObject<MappableDataArray<VehicleModel>>?, AFError> {
        let promise = Promise<ResponseObject<MappableDataArray<VehicleModel>>?, AFError>()
        
        var endpoint = "/v1/vehicle-models"
        if let makeId = makeId {
            endpoint += "/\(makeId)"
        }
        
        NetworkRequest.request(url: endpoint, queryParameters: nil, withBearer: false).responseJSON { response in
            
            var responseObject: ResponseObject<MappableDataArray<VehicleModel>>?
            
            if let json = response.result.value as? [String: Any] {
                responseObject = ResponseObject<MappableDataArray<VehicleModel>>(json: json)
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
