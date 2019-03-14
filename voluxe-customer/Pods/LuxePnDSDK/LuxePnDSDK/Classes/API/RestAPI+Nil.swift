//
//  RestAPI+Nil.swift
//  LuxePnDSDK
//
//  Created by Johan Giroux on 3/11/19.
//

import Foundation

extension RestAPI {
    
    func get(route: RestAPIRoute,
             queryParameters: RestAPIParameters? = nil,
             completion: RestAPICompletion? = nil)
    {
    }
    
    func patch(route: RestAPIRoute,
               bodyParameters: RestAPIParameters?,
               completion: RestAPICompletion?)
    {
    }
    
    func delete(route: RestAPIRoute,
                bodyParameters: RestAPIParameters? = nil,
                completion: RestAPICompletion?)
    {
    }
    
    func put(route: RestAPIRoute,
             bodyParameters: RestAPIParameters? = nil,
             bodyJSON: Data? = nil,
             completion: RestAPICompletion? = nil)
    {
    }
    
    func post(route: RestAPIRoute,
              queryParameters: RestAPIParameters? = nil,
              bodyParameters: RestAPIParameters? = nil,
              completion: RestAPICompletion? = nil)
    {
    }
}
