//
//  CustomerAPI+Vehicle.swift
//  voluxe-customer
//
//  Created by Christoph on 5/17/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper
import BrightFutures
import Foundation

extension CustomerAPI {

    /**
     Get the Customer's Vehicles
     - parameter id: Customer's Id

     - Returns: A Future ResponseObject containing a list of Vehicle, or an AFError if an error occured
     */
    func getVehicles(customerId: Int) -> Future<ResponseObject<MappableDataArray<Vehicle>>?, Errors> {
        let promise = Promise<ResponseObject<MappableDataArray<Vehicle>>?, Errors>()

        NetworkRequest.request(url: "/v1/customers/\(customerId)/vehicles", queryParameters: [:], withBearer: true).responseJSONErrorCheck { response in

            let responseObject = ResponseObject<MappableDataArray<Vehicle>>(json: response.result.value, allowEmptyData: false)

            if response.error == nil && responseObject.error == nil {
                promise.success(responseObject)
            } else {
                promise.failure(Errors(dataResponse: response, apiError: responseObject.error))
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
    func addVehicle(customerId: Int, make: String, model: String, baseColor: String, year: Int) -> Future<ResponseObject<MappableDataObject<Vehicle>>?, Errors> {
        let promise = Promise<ResponseObject<MappableDataObject<Vehicle>>?, Errors>()

        let params: Parameters = [
            "make": make,
            "model": model,
            "base_color": baseColor,
            "year": year
        ]

        NetworkRequest.request(url: "/v1/customers/\(customerId)/vehicles", queryParameters: nil, bodyParameters: params, withBearer: true).responseJSONErrorCheck { response in

            let responseObject = ResponseObject<MappableDataObject<Vehicle>>(json: response.result.value, allowEmptyData: false)

            if response.error == nil && responseObject.error == nil {
                promise.success(responseObject)
            } else {
                promise.failure(Errors(dataResponse: response, apiError: responseObject.error))
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
    func deleteVehicle(customerId: Int, vehicleId: Int) -> Future<ResponseObject<EmptyMappableObject>?, Errors> {
        let promise = Promise<ResponseObject<EmptyMappableObject>?, Errors>()

        NetworkRequest.request(url: "/v1/customers/\(customerId)/vehicles/\(vehicleId)", method: .delete, queryParameters: nil, withBearer: true).responseJSONErrorCheck { response in

            let responseObject = ResponseObject<EmptyMappableObject>(json: response.result.value)

            if response.error == nil && responseObject.error == nil {
                promise.success(responseObject)
            } else {
                promise.failure(Errors(dataResponse: response, apiError: responseObject.error))
            }
        }
        return promise.future
    }
}
