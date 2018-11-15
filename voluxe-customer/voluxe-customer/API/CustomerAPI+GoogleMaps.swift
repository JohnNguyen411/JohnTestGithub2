//
//  CustomerAPI+GoogleMaps.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 11/14/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

extension CustomerAPI {
    
    /**
     Endpoint to update Customer's phone number
     - parameter customerId: Customer's ID
     - parameter phoneNumber: The new customer Phone Number
     - parameter completion: A closure which is called with a LuxeAPIError if an error occured
     */
    static func distance(origin: String, destination: String, mode: String?,
                                  completion: @escaping ((GMDistanceMatrix?, LuxeAPIError?) -> Void)) {
        
        let key = Config.sharedInstance.mapAPIKey()
        //let headers: HTTPHeaders = ["Accept": "application/json", "Content-Type": "application/json"]
        
        let route = "https://maps.googleapis.com/maps/api/distancematrix/json?key=\(key)&origins=\(origin)&destinations=\(destination)"
        if let encodedUrl = route.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {

            self.api.get(route: encodedUrl) {
                response in
                let distanceMatrix: GMDistanceMatrix? = response?.decode()
                completion(distanceMatrix, response?.asError())
            }
        } else {
            // error
            completion(nil, LuxeAPIError(code: nil, message: nil, statusCode: 400)) // bad request

        }
    }
    
    /**
     Endpoint to update Customer's phone number
     - parameter customerId: Customer's ID
     - parameter phoneNumber: The new customer Phone Number
     - parameter completion: A closure which is called with a LuxeAPIError if an error occured
     */
    static func snappedPoints(from: String, to: String,
                         completion: @escaping ((GMSnappedPoints?, LuxeAPIError?) -> Void)) {
        
        let key = Config.sharedInstance.mapAPIKey()
        //let headers: HTTPHeaders = ["Accept": "application/json", "Content-Type": "application/json"]
        
        let route = "https://roads.googleapis.com/v1/snapToRoads?path=\(from)|\(to)&interpolate=true&key=\(key)"
        if let encodedUrl = route.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            
            self.api.get(route: encodedUrl) {
                response in
                let snappedPoints: GMSnappedPoints? = response?.decode()
                completion(snappedPoints, response?.asError())
            }
        } else {
            // error
            completion(nil, LuxeAPIError(code: nil, message: nil, statusCode: 400)) // bad request
        }
    }
    
    static func coordinatesToString(coordinate: CLLocationCoordinate2D) -> String {
        return "\(coordinate.latitude),\(coordinate.longitude)"
    }
}

