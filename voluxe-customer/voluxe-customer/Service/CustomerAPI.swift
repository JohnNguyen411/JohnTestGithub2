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
     Logout
     Logout the currently logged user
     
     - Returns: A Future ResponseObject containing an empty Object, or an AFError if an error occured
     */
    func logout() -> Future<ResponseObject<EmptyMappableObject>?, AFError> {
        let promise = Promise<ResponseObject<EmptyMappableObject>?, AFError>()
        
        NetworkRequest.request(url: "/v1/users/logout", method: .post, queryParameters: [:], withBearer: true).responseJSON { response in
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
        
        NetworkRequest.request(url: "/v1/users/login", queryParameters: nil, bodyParameters: params, withBearer: false).responseJSONErrorCheck { response in
            
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
        
        NetworkRequest.request(url: "/v1/customers/signup", queryParameters: nil, bodyParameters: params, withBearer: false).responseJSONErrorCheck { response in
            
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
            "password": password,
            "verification_code": verificationCode
        ]
        
        NetworkRequest.request(url: "/v1/customers/signup/confirm", queryParameters: nil, bodyParameters: params, withBearer: false).responseJSONErrorCheck { response in
            
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
     Endpoint to request Customer's phone number verification code
     - parameter customerId: Customer's ID
     
     - Returns: A Future ResponseObject containing a Customer Object, or an AFError if an error occured
     */
    func requestPhoneVerificationCode(customerId: Int) -> Future<ResponseObject<EmptyMappableObject>?, AFError> {
        let promise = Promise<ResponseObject<EmptyMappableObject>?, AFError>()
        
        NetworkRequest.request(url: "/v1/customers/\(customerId)/phone-number/request-verification", method: .put, queryParameters: nil, withBearer: true).responseJSON { response in
            
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
     Endpoint to verify Customer's phone number
     - parameter customerId: Customer's ID
     - parameter verificationCode: Verification Code sent by SMS
     
     - Returns: A Future ResponseObject containing a Customer Object, or an AFError if an error occured
     */
    func verifyPhoneNumber(customerId: Int, verificationCode: String) -> Future<ResponseObject<EmptyMappableObject>?, AFError> {
        let promise = Promise<ResponseObject<EmptyMappableObject>?, AFError>()
        
        let params: Parameters = [
            "verification_code": verificationCode
        ]
        
        NetworkRequest.request(url: "/v1/customers/\(customerId)/phone-number/verify", method: .put, queryParameters: nil, bodyParameters: params, withBearer: true).responseJSONErrorCheck { response in
            
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
     Endpoint to update Customer's phone number
     - parameter customerId: Customer's ID
     - parameter phoneNumber: The new customer Phone Number
     
     - Returns: A Future ResponseObject containing a Customer Object, or an AFError if an error occured
     */
    func updatePhoneNumber(customerId: Int, phoneNumber: String) -> Future<ResponseObject<EmptyMappableObject>?, AFError> {
        let promise = Promise<ResponseObject<EmptyMappableObject>?, AFError>()
        
        let params: Parameters = [
            "phone_number": phoneNumber
        ]
        
        NetworkRequest.request(url: "/v1/customers/\(customerId)", method: .patch, queryParameters: nil, bodyParameters: params, withBearer: true).responseJSON { response in
            
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
     Endpoint to initiate Customer's reset password
     - parameter customerId: Customer's ID
     
     - Returns: A Future ResponseObject containing an empty Object, or an AFError if an error occured
     */
    func requestPasswordChange(customerId: Int) -> Future<ResponseObject<EmptyMappableObject>?, AFError> {
        let promise = Promise<ResponseObject<EmptyMappableObject>?, AFError>()
        
        NetworkRequest.request(url: "/v1/customers/\(customerId)/password/request-change", method: .put, queryParameters: nil, withBearer: true).responseJSONErrorCheck { response in
            
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
     Endpoint to reset Customer's password
     - parameter customerId: Customer's ID
     - parameter code: The verification code the customer received
     - parameter password: The new password
     
     - Returns: A Future ResponseObject containing an empty Object, or an AFError if an error occured
     */
    func passwordChange(customerId: Int, code: String, password: String) -> Future<ResponseObject<EmptyMappableObject>?, AFError> {
        let promise = Promise<ResponseObject<EmptyMappableObject>?, AFError>()
        
        let params: Parameters = [
            "verification_code": code,
            "password": password
        ]
        
        NetworkRequest.request(url: "/v1/customers/\(customerId)/password/change", method: .put, queryParameters: nil, bodyParameters: params, withBearer: true).responseJSONErrorCheck { response in
            
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
     Endpoint to initiate Customer's reset password from phone number
     - parameter phoneNumber: Customer's phone number
     
     - Returns: A Future ResponseObject containing an empty Object, or an AFError if an error occured
     */
    func passwordReset(phoneNumber: String) -> Future<ResponseObject<EmptyMappableObject>?, AFError> {
        let promise = Promise<ResponseObject<EmptyMappableObject>?, AFError>()
        
        let params: Parameters = [
            "phone_number": phoneNumber
        ]
        
        NetworkRequest.request(url: "/v1/customers/password-reset/request", method: .put, queryParameters: nil, bodyParameters: params,  withBearer: true).responseJSONErrorCheck { response in
            
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
     Endpoint to set a new password for the customer using a 2FA verification code.
     - parameter phoneNumber: Customer's phone number
     - parameter code: The verification code the customer received
     - parameter password: The new password
     
     - Returns: A Future ResponseObject containing an empty Object, or an AFError if an error occured
     */
    func passwordResetConfirm(phoneNumber: String, code: String, password: String) -> Future<ResponseObject<EmptyMappableObject>?, AFError> {
        let promise = Promise<ResponseObject<EmptyMappableObject>?, AFError>()
        
        let params: Parameters = [
            "phone_number": phoneNumber,
            "verification_code": code,
            "password": password
        ]
        
        NetworkRequest.request(url: "/v1/customers/password-reset/confirm", method: .put, queryParameters: nil, bodyParameters: params, withBearer: true).responseJSONErrorCheck { response in
            
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
        
        NetworkRequest.request(url: "/v1/customers/\(id)", queryParameters: [:], withBearer: true).responseJSONErrorCheck { response in
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
     Get the Customer object for the logged user
     
     - Returns: A Future ResponseObject containing a Customer Object, or an AFError if an error occured
     */
    func getMe() -> Future<ResponseObject<MappableDataObject<Customer>>?, AFError> {
        let promise = Promise<ResponseObject<MappableDataObject<Customer>>?, AFError>()
        
        NetworkRequest.request(url: "/v1/users/me", queryParameters: [:], withBearer: true).responseJSONErrorCheck { response in
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
        
        NetworkRequest.request(url: "/v1/customers/\(customerId)/vehicles", queryParameters: [:], withBearer: true).responseJSONErrorCheck { response in
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
    
    /**
     Add new vehicle to Customer
     - parameter customerId: Customer's Id
     - parameter make: Make of the new vehicle
     - parameter model: Model of the new vehicle
     - parameter year: Year of the new vehicle
     
     
     - Returns: A Future ResponseObject containing the added vehicle, or an AFError if an error occured
     */
    func addVehicle(customerId: Int, make: String, model: String, baseColor: String, year: Int) -> Future<ResponseObject<MappableDataObject<Vehicle>>?, AFError> {
        let promise = Promise<ResponseObject<MappableDataObject<Vehicle>>?, AFError>()
        
        let params: Parameters = [
            "make": make,
            "model": model,
            "base_color": baseColor,
            "year": year
        ]
        
        NetworkRequest.request(url: "/v1/customers/\(customerId)/vehicles", queryParameters: nil, bodyParameters: params, withBearer: true).responseJSONErrorCheck { response in

            var responseObject: ResponseObject<MappableDataObject<Vehicle>>?
            
            if let json = response.result.value as? [String: Any] {
                responseObject = ResponseObject<MappableDataObject<Vehicle>>(json: json)
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
     Endpoint to remove a vehicle from Customer
     - parameter customerId: Customer's ID
     - parameter vehicleId: Vehicle ID
     
     - Returns: A Future ResponseObject Empty, or an AFError if an error occured
     */
    func deleteVehicle(customerId: Int, vehicleId: Int) -> Future<ResponseObject<EmptyMappableObject>?, AFError> {
        let promise = Promise<ResponseObject<EmptyMappableObject>?, AFError>()
        
        NetworkRequest.request(url: "/v1/customers/\(customerId)/vehicles/\(vehicleId)", method: .delete, queryParameters: nil, withBearer: true).responseJSONErrorCheck { response in
            
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
     Add new vehicle to Customer
     - parameter customerId: Customer's Id
     - parameter deviceToken: Device token for push notifs
     
     - Returns: A Future ResponseObject containing an empty data response, or an AFError if an error occured
     */
    func registerDevice(customerId: Int, deviceToken: String) -> Future<ResponseObject<EmptyMappableObject>?, AFError> {
        let promise = Promise<ResponseObject<EmptyMappableObject>?, AFError>()
        
        var uuid = ""
        if let identifierForVendor = UIDevice.current.identifierForVendor?.uuidString {
            uuid = identifierForVendor
        }
        
        let params: Parameters = [
            "os": "ios",
            "os_version": UIDevice.current.systemVersion,
            "unique_identifier": uuid,
            "address": deviceToken
        ]
        
        NetworkRequest.request(url: "/v1/customers/\(customerId)/devices/current", method: .put, queryParameters: nil, bodyParameters: params, withBearer: true).responseJSONErrorCheck { response in
            
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
}

