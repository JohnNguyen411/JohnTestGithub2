//
//  CustomerAPI.swift
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

/// Class regrouping all the methods creating requests to handle Customer
class CustomerAPI: NSObject {
    
    /**
     Get the Customer object with a customerId
     - parameter id: Customer's Id
     
     - Returns: A Future ResponseObject containing a Customer Object, or an AFError if an error occured
     */
    func getCustomer(id: String) -> Future<ResponseObject<MappableDataObject<Customer>>?, AFError> {
        let promise = Promise<ResponseObject<MappableDataObject<Customer>>?, AFError>()
        
        NetworkRequest.request(url: NetworkRequest.replaceValues(url: "/v1/customers/\(NetworkRequest.ID_PLACEHOLDER)", values: [id]), queryParameters: [:], withBearer: true).responseJSON { response in
            
            var responseObject: ResponseObject<MappableDataObject<Customer>>?
            
            if let json = response.result.value as? [String: Any] {
                Logger.print("JSON: \(json)")
                responseObject = ResponseObject<MappableDataObject<Customer>>(json: json)
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
     Get the Customer's Vehicles
     - parameter id: Customer's Id
     
     - Returns: A Future ResponseObject containing a list of Vehicle, or an AFError if an error occured
     */
    func getVehicles(customerId: String) -> Future<ResponseObject<MappableDataArray<Vehicle>>?, AFError> {
        let promise = Promise<ResponseObject<MappableDataArray<Vehicle>>?, AFError>()
        
        NetworkRequest.request(url: NetworkRequest.replaceValues(url: "/v1/customers/\(NetworkRequest.ID_PLACEHOLDER)/vehicles", values: [customerId]), queryParameters: [:], withBearer: true).responseJSON { response in
            
            var responseObject: ResponseObject<MappableDataArray<Vehicle>>?
            
            if let json = response.result.value as? [String: Any] {
                Logger.print("JSON: \(json)")
                responseObject = ResponseObject<MappableDataArray<Vehicle>>(json: json)
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

