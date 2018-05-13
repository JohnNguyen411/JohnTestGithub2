//
//  GoogleDistanceMatrixAPI.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/16/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire
import AlamofireObjectMapper
import BrightFutures

class GoogleDistanceMatrixAPI: NSObject {
    
    func getDirection(origin: String!, destination: String!, mode: String?) -> Future<GMDistanceMatrix?, AFError> {
        let promise = Promise<GMDistanceMatrix?, AFError>()
        
        let key = Config.sharedInstance.mapAPIKey()
        let headers: HTTPHeaders = ["Accept": "application/json", "Content-Type": "application/json"]
        do {
            let originalRequest = try URLRequest(url: "https://maps.googleapis.com/maps/api/distancematrix/json", method: .get, headers: headers)
            var queryEncodedURLRequest = try URLEncoding.default.encode(originalRequest, with: ["origins": origin, "destinations": destination, "key": key])
            Alamofire.request(queryEncodedURLRequest).responseObject { (resp: DataResponse<GMDistanceMatrix>) in
                if resp.error == nil {
                    promise.success(resp.value)
                } else {
                    promise.failure(Errors.safeAFError(error: resp.error!))
                }
            }
            
        } catch {
            // cant do request
        }
        return promise.future
    }
    
    static func coordinatesToString(coordinate: CLLocationCoordinate2D) -> String {
        return "\(coordinate.latitude),\(coordinate.longitude)"
    }
}
