//
//  CustomerAPI+Vehicle.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 11/7/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

extension CustomerAPI {
    
    /**
     Get the Customer's Vehicles
     - parameter customerId: Customer's ID
     - parameter completion: A closure which is called with an array of Vehicle or if an error occured
     */
    static func vehicles(customerId: Int,
                         completion: @escaping (([Vehicle], LuxeAPIError.Code?) -> Void)) {
        let route = "v1/customers/\(customerId)/vehicles"
        
        self.api.get(route: route) {
            response in
            let vehicles = response?.decodeCustomerVehicles() ?? []
            completion(vehicles, response?.asErrorCode())
        }
    }
    
    /**
     Add new vehicle to Customer
     - parameter customerId: Customer's Id
     - parameter make: Make of the new vehicle
     - parameter model: Model of the new vehicle
     - parameter year: Year of the new vehicle
     - parameter completion: A closure which is called with an array of Vehicle or if an error occured
     */
    static func addVehicle(customerId: Int, make: String, model: String, baseColor: String, year: Int,
                           completion: @escaping (([Vehicle], LuxeAPIError.Code?) -> Void)) {
        
        let params = [
            "make": make,
            "model": model,
            "base_color": baseColor,
            "year": year
        ]
        
        self.api.post(route: "v1/customers/\(customerId)/vehicles", bodyParameters: parameters) {
            response in
            let vehicles = response?.decodeCustomerVehicles() ?? []
            completion(vehicles, response?.asErrorCode())
        }
    }
    
    /**
     Endpoint to remove a vehicle from Customer
     - parameter customerId: Customer's ID
     - parameter vehicleId: Vehicle ID
     - parameter completion: A closure which is called with an array of Vehicle or if an error occured
     */
    static func deleteVehicle(customerId: Int, vehicleId: Int,
                           completion: @escaping (([Vehicle], LuxeAPIError.Code?) -> Void)) {
       
        self.api.delete(route: "v1/customers/\(customerId)/vehicles/\(vehicleId)", bodyParameters: parameters) {
            response in
            let vehicles = response?.decodeCustomerVehicles() ?? []
            completion(vehicles, response?.asErrorCode())
        }
    }
}

fileprivate extension RestAPIResponse {
    
    private struct VehiclesResponse: Codable {
        let data: [Vehicle]
    }
    
    func decodeCustomerVehicles() -> [Vehicle]? {
        let vehiclesResponse: VehiclesResponse? = self.decode()
        return vehiclesResponse?.data
    }
}
