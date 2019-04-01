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
     - parameter completion: A closure which is called with an array of Vehicle or LuxeAPIError if an error occured
     */
    public static func vehicles(customerId: Int,
                         completion: @escaping (([Vehicle], LuxeAPIError?) -> Void)) {
        let route = "v1/customers/\(customerId)/vehicles"
        
        self.api.get(route: route) {
            response in
            let vehicles = response?.decodeCustomerVehicles() ?? []
            completion(vehicles, response?.asError())
        }
    }
    
    /**
     Add new vehicle to Customer
     - parameter customerId: Customer's Id
     - parameter make: Make of the new vehicle
     - parameter model: Model of the new vehicle
     - parameter year: Year of the new vehicle
     - parameter completion: A closure which is called with the added Vehicle or LuxeAPIError if an error occured
     */
    public static func addVehicle(customerId: Int, make: String, model: String, baseColor: String, year: Int,
                           completion: @escaping ((Vehicle?, LuxeAPIError?) -> Void)) {
        
        let params = [
            "make": make,
            "model": model,
            "base_color": baseColor,
            "year": "\(year)"
        ]
        
        
        self.api.post(route: "v1/customers/\(customerId)/vehicles", bodyParameters: params) {
            response in
            let vehicle = response?.decodeCustomerVehicle() ?? nil
            completion(vehicle, response?.asError())
        }
    }
    
    /**
     Endpoint to remove a vehicle from Customer
     - parameter customerId: Customer's ID
     - parameter vehicleId: Vehicle ID
     - parameter completion: A closure which is called with an array of Vehicle or LuxeAPIError if an error occured
     */
    public static func deleteVehicle(customerId: Int, vehicleId: Int,
                           completion: @escaping (([Vehicle], LuxeAPIError?) -> Void)) {
       
        self.api.delete(route: "v1/customers/\(customerId)/vehicles/\(vehicleId)") {
            response in
            let vehicles = response?.decodeCustomerVehicles() ?? []
            completion(vehicles, response?.asError())
        }
    }
    
    /**
     Retrieve list of Makes available for Vehicles
     - parameter completion: A closure which is called with an array of VehicleMakes or LuxeAPIError if an error occured
     */
    public static func vehicleMakes(completion: @escaping (([VehicleMake], LuxeAPIError?) -> Void)) {
        let params: [String: Any] = ["managed":true, "limit":99, "sort[0]":"-name"]

        self.api.get(route: "v1/vehicle-makes", queryParameters: params) {
            response in
            let vehicles = response?.decodeVehicleMakes() ?? []
            completion(vehicles, response?.asError())
        }
    }
    
    /**
     Retrieve list of Models available for Vehicles
     - parameter makeId: Make Id for the desired models (Optional
     - parameter completion: A closure which is called with an array of VehicleModel or LuxeAPIError if an error occured
     */
    public static func vehicleModels(makeId: Int?, completion: @escaping (([VehicleModel], LuxeAPIError?) -> Void)) {

        var queryParams = [
            "managed": "true",
            "limit": 99,
            "sort[0]": "-name"
            ] as [String : Any]
        
        if let makeId = makeId {
            queryParams["make"] = makeId
        }
        
        
        self.api.get(route: "v1/vehicle-models", queryParameters: queryParams) {
            response in
            let vehicles = response?.decodeVehicleModels() ?? []
            completion(vehicles, response?.asError())
        }
    }
}

fileprivate extension RestAPIResponse {
    
    private struct VehicleModelsResponse: Codable {
        let data: [VehicleModel]
    }
    
    func decodeVehicleModels() -> [VehicleModel]? {
        let vehicleModelsResponse: VehicleModelsResponse? = self.decode()
        return vehicleModelsResponse?.data
    }
    
    private struct VehicleMakesResponse: Codable {
        let data: [VehicleMake]
    }
    
    func decodeVehicleMakes() -> [VehicleMake]? {
        let vehicleMakesResponse: VehicleMakesResponse? = self.decode()
        return vehicleMakesResponse?.data
    }
    
    private struct VehiclesResponse: Codable {
        let data: [Vehicle]
    }
    
    func decodeCustomerVehicles() -> [Vehicle]? {
        let vehiclesResponse: VehiclesResponse? = self.decode()
        return vehiclesResponse?.data
    }
    
    private struct VehicleResponse: Codable {
        let data: Vehicle
    }
    
    func decodeCustomerVehicle() -> Vehicle? {
        let vehicleResponse: VehicleResponse? = self.decode()
        return vehicleResponse?.data
    }
}
