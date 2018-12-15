//
//  RealmObjectConverter.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 12/14/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift

public protocol RealmObjectConverter {
    
    associatedtype Model // The model object
    associatedtype Origin: Object // the Realm Object
    
    static func convertToModel(element: Origin) -> Model
    static func convertModelToRealm(element: Model) -> Origin
    static func convertResultsToModel(results: Results<Origin>) -> [Model]
    static func convertModelsToRealm(elements: [Model]) -> [Origin]
    
}
