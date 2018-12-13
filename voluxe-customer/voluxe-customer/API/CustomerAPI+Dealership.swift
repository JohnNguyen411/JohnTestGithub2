//
//  CustomerAPI+Dealership.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 11/13/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

extension CustomerAPI {

    /**
     Get a list of Dealership
     - parameter completion: A closure which is called with an array of Dealership Object or LuxeAPIError if an error occured
     */
    static func dealerships(completion: @escaping (([Dealership], LuxeAPIError?) -> Void)) {
        
        self.api.get(route: "v1/dealerships") {
            response in
            let dealerships = response?.decodeDealerships() ?? []
            completion(dealerships, response?.asError())
        }
    }
    
    /**
     Get a list of Dealership servicing a Location
     - parameter completion: A closure which is called with an array of Dealership Object or LuxeAPIError if an error occured
     */
    static func dealerships(location: CLLocationCoordinate2D, completion: @escaping (([Dealership], LuxeAPIError?) -> Void)) {
        
        let params = ["latitude": "\(location.latitude)", "longitude" : "\(location.longitude)"]
        
        self.api.get(route: "v1/dealerships/within-coverage", queryParameters: params) {
            response in
            let dealerships = response?.decodeDealerships() ?? []
            completion(dealerships, response?.asError())
        }
    }
    
    /**
     Get a list of Time slot for a dealership
     - parameter dealershipId: the dealership_id
     - parameter type: the type of TimeSlot (driver, advisor). `driver` for Pickup/Delivery, `advisor` for "self" IB/OB
     - parameter loaner: true if loaner is requested, false otherwise
     - parameter from: start date of the requested timeslot
     - parameter to: end date of the requested timeslot
     - parameter completion: A closure which is called with an array of DealershipTimeSlot Object or LuxeAPIError if an error occured
     */
    static func dealershipTimeSlot(dealershipId: Int, type: String, loaner: Bool, from: String, to: String,
                            completion: @escaping (([DealershipTimeSlot], LuxeAPIError?) -> Void)) {
        
        let params = [
            "type": type,
            "start": from,
            "end": to,
            "compute[0]": "available_loaner_vehicle_count", // request the loaner vehicle count in the response
            "compute[1]": "available_assignment_count", // request the number of available assignment for each slots
            ] as [String : Any]
        
        self.api.get(route: "v1/dealerships/\(dealershipId)/time-slots/scheduled", queryParameters: params) {
            response in
            let dealershipTimeSlots = response?.decodeDealershipTimeSlotsResponse() ?? []
            completion(dealershipTimeSlots, response?.asError())
        }
    }
    
}


fileprivate extension RestAPIResponse {
    
    private struct DealershipsResponse: Codable {
        let data: [Dealership]
    }
    
    func decodeDealerships() -> [Dealership]? {
        let dealershipsResponse: DealershipsResponse? = self.decode()
        return dealershipsResponse?.data
    }
    
    private struct DealershipTimeSlotsResponse: Codable {
        let data: [DealershipTimeSlot]
    }
    
    func decodeDealershipTimeSlotsResponse() -> [DealershipTimeSlot]? {
        let dealershipTimeSlotsResponse: DealershipTimeSlotsResponse? = self.decode()
        return dealershipTimeSlotsResponse?.data
    }
    
}
