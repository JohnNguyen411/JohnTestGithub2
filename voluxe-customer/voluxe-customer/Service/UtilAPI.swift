//
//  UtilAPI.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 4/25/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import BrightFutures

class UtilAPI: NSObject {
    
    /**
     Check if the app needs a Force Upgrade
     
     - Returns: A Future ResponseObject containing the last force upgrade build number, or an AFError if an error occured
     */
    func needForceUpgrade() -> Future<ResponseObject<MappableDataObject<ForceUpgrade>>?, AFError> {
        let promise = Promise<ResponseObject<MappableDataObject<ForceUpgrade>>?, AFError>()
        
        NetworkRequest.request(url: "/v1/force-upgrade", queryParameters: nil, withBearer: true).responseJSON { response in
            
            var responseObject: ResponseObject<MappableDataObject<ForceUpgrade>>?
            
            if let json = response.result.value as? [String: Any] {
                responseObject = ResponseObject<MappableDataObject<ForceUpgrade>>(json: json)
            }
            
            if response.error == nil {
                promise.success(responseObject)
            } else {
                promise.failure(Errors.safeAFError(error: response.error!))
            }
        }
        return promise.future
    }
}
