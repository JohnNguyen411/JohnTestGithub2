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

        Alamofire.request("https://maps.googleapis.com/maps/api/distancematrix/json", parameters: ["origins": origin, "destinations": destination]).responseObject { (resp: DataResponse<GMDistanceMatrix>) in
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
