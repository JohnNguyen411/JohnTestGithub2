//
//  ResponseObject.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 12/7/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class ResponseObject<T: Mappable> {
    
    /**
     init a ResponseObject
     - parameter json: The json Data to transform
     - parameter allowEmptyData: Whether or not to throw an error when the data is empty

     - Returns: A ResponseObject containing the desired ResponseObject Type, or an Error if an error occured
     */
    init(json: Any?, allowEmptyData: Bool = true) {
        
        if let json = json as? [String: Any] {
            if let jsonMeta = json["meta"] as? [String: Any] {
                meta = Meta(JSON: jsonMeta)
            }
            data = Mapper<T>().map(JSON: json)
            
            if let error = json["error"] {
                if error as! Bool {
                    self.error = ResponseError(JSON: json)
                }
            } else if !allowEmptyData && (json.count == 0 || data == nil) {
                handleEmptyData()
            }
        }
        // throw error in case of empty data if needed, default is false
        else if !allowEmptyData {
            handleEmptyData()
        }
    }
    
    private func handleEmptyData() {
        self.error = ResponseError.emptyDataError()
    }
    
    var meta: Meta?
    var data: T?
    var error: ResponseError?

}
