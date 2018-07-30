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
    func vehicleMakes() -> Future<ResponseObject<MappableDataArray<VehicleMake>>?, Errors> {
        let promise = Promise<ResponseObject<MappableDataArray<VehicleMake>>?, Errors>()
        
        let params: Parameters = ["managed":true, "limit":99, "sort":"-name"]
        
        NetworkRequest.request(url: "/v1/vehicle-makes", queryParameters: params, withBearer: true).responseJSONErrorCheck { response in
            
            let responseObject = ResponseObject<MappableDataArray<VehicleMake>>(json: response.result.value, allowEmptyData: false)
            
            if response.error == nil && responseObject.error == nil {
                promise.success(responseObject)
            } else {
                promise.failure(Errors(dataResponse: response, apiError: responseObject.error))
            }
            
        }
        return promise.future
    }
    
    /**
     Retrieve list of Models available for Vehicles
     - parameter makeId: Make Id for the desired models (Optional)

     - Returns: A Future ResponseObject containing an Array of VehicleModel, or an AFError if an error occured
     */
    func vehicleModels(makeId: Int?) -> Future<ResponseObject<MappableDataArray<VehicleModel>>?, Errors> {
        let promise = Promise<ResponseObject<MappableDataArray<VehicleModel>>?, Errors>()
        
        var queryParams = [
            "managed": "true",
            "limit": 99,
            "sort": "-name"
            ] as [String : Any]
        
        if let makeId = makeId {
            queryParams["make"] = makeId
        }
        
        NetworkRequest.request(url: "/v1/vehicle-models", queryParameters: queryParams, withBearer: true).responseJSONErrorCheck { response in
            
            let responseObject = ResponseObject<MappableDataArray<VehicleModel>>(json: response.result.value, allowEmptyData: false)
            
            if response.error == nil && responseObject.error == nil {
                promise.success(responseObject)
            } else {
                promise.failure(Errors(dataResponse: response, apiError: responseObject.error))
            }

        }
        return promise.future
    }
}
