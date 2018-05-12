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

        Alamofire.request("https://maps.googleapis.com/maps/api/distancematrix/json", method: .get, parameters: ["origins": origin, "destinations": destination, "key": key], encoding: JSONEncoding.default, headers : headers).responseObject { (resp: DataResponse<GMDistanceMatrix>) in
            if resp.error == nil {
                promise.success(resp.value)
            } else {
                promise.failure(resp.error as! AFError)
            }
        }
        return promise.future
    }
    
    static func coordinatesToString(coordinate: CLLocationCoordinate2D) -> String {
        return "\(coordinate.latitude),\(coordinate.longitude)"
    }
}
