//
//  RepairOrderAPI.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 3/16/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import BrightFutures

/// Class regrouping all the methods related to Repair Orders
class RepairOrderAPI: NSObject {
    
    
    /**
     Get all the available Repair Order Types
     
     - Returns: A Future ResponseObject containing a Booking, or an AFError if an error occured
     */
    func getRepairOrderTypes() -> Future<ResponseObject<MappableDataArray<RepairOrderType>>?, AFError> {
        let promise = Promise<ResponseObject<MappableDataArray<RepairOrderType>>?, AFError>()
        
        
        NetworkRequest.request(url: "/v1/repair-order-types/", queryParameters: nil, withBearer: true).responseJSON { response in
            var responseObject: ResponseObject<MappableDataArray<RepairOrderType>>?
            
            if let json = response.result.value as? [String: Any] {
                responseObject = ResponseObject<MappableDataArray<RepairOrderType>>(json: json)
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

