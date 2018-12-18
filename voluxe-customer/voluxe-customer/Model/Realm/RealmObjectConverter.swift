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

public class RealmObject {
    
    static func convertResultsToModel<T: RealmObjectConverter>(results: Results<T.Origin>, type: T.Type) -> [T.Model] {
        var convertedElements: [T.Model] = []
        results.forEach { element in
            convertedElements.append(type.convertToModel(element: element))
        }
        
        return convertedElements
    }
    
    static func convertModelsToRealm<T: RealmObjectConverter>(elements: [T.Model], type: T.Type) -> [T.Origin] {
        var convertedElements: [T.Origin] = []
        elements.forEach { element in
            convertedElements.append(type.convertModelToRealm(element: element))
        }
        
        return convertedElements
    }
    
 
}
