//
//  BookingAPI.swift
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

class BookingAPI: NSObject {
    
    func createBooking(customerId: String, vehicleId: String, dealershipId: String, loaner: Bool) -> Future<ResponseObject<MappableDataObject<Customer>>?, AFError> {
        let promise = Promise<ResponseObject<MappableDataObject<Customer>>?, AFError>()
        let params: Parameters = [
            "customer_id": customerId,
            "vehicle_id": vehicleId,
            "dealership_id": dealershipId,
            "loaner_vehicle_requested": loaner,
        ]
        
        NetworkRequest.request(url: "/v1/bookings", queryParameters: nil, bodyParameters: params, withBearer: true).responseJSON { response in
            
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
}
