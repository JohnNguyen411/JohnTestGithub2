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
     Login endpoint for Customer
     - parameter email: Customer's email
     - parameter password: Customer's password

     - Returns: A Future ResponseObject containing a Token Object, or an AFError if an error occured
     */
    func login(email: String, password: String) -> Future<ResponseObject<MappableDataObject<Token>>?, AFError> {
        let promise = Promise<ResponseObject<MappableDataObject<Token>>?, AFError>()
        
        let params: Parameters = [
            "email": email,
            "password": password
        ]
        
        NetworkRequest.request(url: "/v1/customers/login", queryParameters: nil, bodyParameters: params, withBearer: false).responseJSON { response in
            
            
            var responseObject: ResponseObject<MappableDataObject<Token>>?
            
            if let json = response.result.value as? [String: Any] {
                responseObject = ResponseObject<MappableDataObject<Token>>(json: json)
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
     Signup endpoint for Customer
     - parameter email: Customer's email
     - parameter password: Customer's password
     - parameter firstName: Customer's firstname
     - parameter lastName: Customer's lastame
     - parameter phoneNumber: Customer's phoneNumber
     
     - Returns: A Future ResponseObject containing a Customer Object, or an AFError if an error occured
     */
    func signup(email: String, password: String, firstName: String, lastName: String, phoneNumber: String) -> Future<ResponseObject<MappableDataObject<Customer>>?, AFError> {
        let promise = Promise<ResponseObject<MappableDataObject<Customer>>?, AFError>()
        
        let params: Parameters = [
            "email": email,
            "password": password,
            "first_name": firstName,
            "last_name": lastName,
            "phone_number": phoneNumber,
            "phone_number_verified": true, //todo remove that
            "credit": 0, //todo remove that
            "currency_id": 1 //todo remove that
        ]
        
        NetworkRequest.request(url: "/v1/customers", queryParameters: nil, bodyParameters: params, withBearer: false).responseJSON { response in
            
            var responseObject: ResponseObject<MappableDataObject<Customer>>?
            
            if let json = response.result.value as? [String: Any] {
                responseObject = ResponseObject<MappableDataObject<Customer>>(json: json)
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
     Get the Customer object with a customerId
     - parameter id: Customer's Id
     
     - Returns: A Future ResponseObject containing a Customer Object, or an AFError if an error occured
     */
    func getCustomer(id: Int) -> Future<ResponseObject<MappableDataObject<Customer>>?, AFError> {
        let promise = Promise<ResponseObject<MappableDataObject<Customer>>?, AFError>()
        
        NetworkRequest.request(url: "/v1/customers/\(id)", queryParameters: [:], withBearer: true).responseJSON { response in
            var responseObject: ResponseObject<MappableDataObject<Customer>>?
            
            if let json = response.result.value as? [String: Any] {
                responseObject = ResponseObject<MappableDataObject<Customer>>(json: json)
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
     Get the Customer's Vehicles
     - parameter id: Customer's Id
     
     - Returns: A Future ResponseObject containing a list of Vehicle, or an AFError if an error occured
     */
    func getVehicles(customerId: Int) -> Future<ResponseObject<MappableDataArray<Vehicle>>?, AFError> {
        let promise = Promise<ResponseObject<MappableDataArray<Vehicle>>?, AFError>()
        
        NetworkRequest.request(url: "/v1/customers/\(customerId)/vehicles", queryParameters: [:], withBearer: true).responseJSON { response in
            var responseObject: ResponseObject<MappableDataArray<Vehicle>>?
            
            if let json = response.result.value as? [String: Any] {
                responseObject = ResponseObject<MappableDataArray<Vehicle>>(json: json)
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

