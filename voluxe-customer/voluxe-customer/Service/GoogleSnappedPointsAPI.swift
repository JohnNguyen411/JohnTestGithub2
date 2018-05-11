//
//  GoogleSnappedPointsAPI.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 5/8/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire
import AlamofireObjectMapper
import BrightFutures

class GoogleSnappedPointsAPI: NSObject {
    
    func getSnappedPoints(from: String, to: String) -> Future<GMSnappedPoints?, AFError> {
        let promise = Promise<GMSnappedPoints?, AFError>()
        
        let key = Config.sharedInstance.mapAPIKey()
        
        let url = "https://roads.googleapis.com/v1/snapToRoads?path=\(from)|\(to)&interpolate=true&key=\(key)"
        if let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            
            Alamofire.request(encodedUrl).responseObject { (resp: DataResponse<GMSnappedPoints>) in
                if resp.error == nil {
                    promise.success(resp.value)
                } else {
                    promise.failure(resp.error as! AFError)
                }
            }
        } else {
            let error = AFError.invalidURL(url: url)
            promise.failure(error)
        }
        
        return promise.future
    }
    
}
