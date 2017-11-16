//
//  GoogleDirectionAPI.swift
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

class GoogleDirectionAPI: NSObject {
    
    func getDirection(origin: String!, destination: String!, mode: String?) -> Future<GMDirection?, AFError> {
        let promise = Promise<GMDirection?, AFError>()

        Alamofire.request("https://maps.googleapis.com/maps/api/directions/json", parameters: ["origin": origin, "destination": destination]).responseObject { (resp: DataResponse<GMDirection>) in
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
