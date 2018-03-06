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
     - parameter phoneNumber: Customer's phoneNumber
     - parameter firstName: Customer's firstname
     - parameter lastName: Customer's lastame
     - parameter languageCode: Customer's ISO_639-3 language code
     
     - Returns: A Future ResponseObject containing a Customer Object, or an AFError if an error occured
     */
    func signup(email: String, phoneNumber: String, firstName: String, lastName: String, languageCode: String) -> Future<ResponseObject<MappableDataObject<Customer>>?, AFError> {
        let promise = Promise<ResponseObject<MappableDataObject<Customer>>?, AFError>()
        
        let params: Parameters = [
            "email": email,
            "phone_number": phoneNumber,
            "first_name": firstName,
            "last_name": lastName,
            "language_code": languageCode
        ]
        
        NetworkRequest.request(url: "/v1/customers/signup", queryParameters: nil, bodyParameters: params, withBearer: false).responseJSON { response in
            
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
     Signup endpoint for Customer
     - parameter email: Customer's email
     - parameter phoneNumber: Customer's phoneNumber
     - parameter password: Customer's password
     - parameter verificationCode: Customer's SMS verification code
     
     - Returns: A Future ResponseObject containing a Customer Object, or an AFError if an error occured
     */
    func confirmSignup(email: String, phoneNumber: String, password: String, verificationCode: String) -> Future<ResponseObject<MappableDataObject<Customer>>?, AFError> {
        let promise = Promise<ResponseObject<MappableDataObject<Customer>>?, AFError>()
        
        let params: Parameters = [
            "email": email,
            "phone_number": phoneNumber,
            "password": password,
            "code": verificationCode
        ]
        
        NetworkRequest.request(url: "/v1/customers/confirm-signup", queryParameters: nil, bodyParameters: params, withBearer: false).responseJSON { response in
            
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
     Signup endpoint for Customer
     - parameter customerId: Customer's ID
     
     - Returns: A Future ResponseObject containing a Customer Object, or an AFError if an error occured
     */
    func requestPhoneVerificationCode(customerId: Int) -> Future<ResponseObject<EmptyMappableObject>?, AFError> {
        let promise = Promise<ResponseObject<EmptyMappableObject>?, AFError>()
        
        NetworkRequest.request(url: "/v1/customers/\(customerId)/request-phone-number-verification", method: .put, queryParameters: nil, withBearer: true).responseJSON { response in
            
            var responseObject: ResponseObject<EmptyMappableObject>?
            
            if let json = response.result.value as? [String: Any] {
                responseObject = ResponseObject<EmptyMappableObject>(json: json)
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
     - parameter customerId: Customer's ID
     - parameter verificationCode: Verification Code sent by SMS
     
     - Returns: A Future ResponseObject containing a Customer Object, or an AFError if an error occured
     */
    func verifyPhoneNumber(customerId: Int, verificationCode: String) -> Future<ResponseObject<EmptyMappableObject>?, AFError> {
        let promise = Promise<ResponseObject<EmptyMappableObject>?, AFError>()
        
        let params: Parameters = [
            "verification_code": verificationCode
        ]
        
        NetworkRequest.request(url: "/v1/customers/\(customerId)/verify-phone-number", method: .put, queryParameters: nil, bodyParameters: params, withBearer: true).responseJSON { response in
            
            var responseObject: ResponseObject<EmptyMappableObject>?
            
            if let json = response.result.value as? [String: Any] {
                responseObject = ResponseObject<EmptyMappableObject>(json: json)
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

