//
//  CustomerAPI+GoogleMaps.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 11/14/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import Alamofire

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
        
        let route = "https://maps.googleapis.com/maps/api/distancematrix/json?key=\(key)&origins=\(origin)&destinations=\(destination)"
        if let encodedUrl = route.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {

            self.sendGoogleMapsRequest(url: encodedUrl, method: .get) {
                response in
                let distanceMatrix: GMDistanceMatrix? = GMDistanceMatrix.decode(data: response?.data)
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
        
        let route = "https://roads.googleapis.com/v1/snapToRoads?path=\(from)|\(to)&interpolate=true&key=\(key)"
        if let encodedUrl = route.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            
            self.sendGoogleMapsRequest(url: encodedUrl, method: .get) {
                response in
                let snappedPoints: GMSnappedPoints? = GMSnappedPoints.decode(data: response?.data)
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
    
    
    static func sendGoogleMapsRequest(url: String, method: Alamofire.HTTPMethod, completion: RestAPICompletion? = nil) {
        
        guard let request = try? URLRequest(url: url, method: method, headers: ["Accept": "application/json", "Content-Type": "application/json"]) else { return }
        
        let sentRequest = Alamofire.AF.request(request)
        print("URL: \(request.url?.absoluteString ?? "")")
        
        sentRequest.responseData {
            response in
            let apiResponse = RestAPIResponse(data: response.result.value, error: response.error, statusCode: response.response?.statusCode)
            completion?(apiResponse)
        }
    }
    
}

