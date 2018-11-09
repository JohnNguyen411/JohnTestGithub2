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
import BrightFutures

class GoogleDistanceMatrixAPI: NSObject {
    
    func getDirection(origin: String, destination: String, mode: String?) -> Future<GMDistanceMatrix?, AFError> {
        let promise = Promise<GMDistanceMatrix?, AFError>()
        
        let key = Config.sharedInstance.mapAPIKey()
        let headers: HTTPHeaders = ["Accept": "application/json", "Content-Type": "application/json"]
        let url = "https://maps.googleapis.com/maps/api/distancematrix/json?key=\(key)&origins=\(origin)&destinations=\(destination)"
        if let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            Alamofire.request(encodedUrl, method: .get, encoding: JSONEncoding.default, headers : headers).responseObject { (resp: DataResponse<GMDistanceMatrix>) in
                if resp.error == nil {
                    promise.success(resp.value)
                } else {
                    promise.failure(Errors.safeAFError(error: resp.error!))
                }
            }
        } else {
            let error = AFError.invalidURL(url: url)
            promise.failure(error)
        }
        
        return promise.future
    }
    
    static func coordinatesToString(coordinate: CLLocationCoordinate2D) -> String {
        return "\(coordinate.latitude),\(coordinate.longitude)"
    }
}
