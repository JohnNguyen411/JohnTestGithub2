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
    
    associatedtype Model: NSObject // The model object, need
    associatedtype Origin: Object // the Realm Object
    
    static func convertToModel(element: Origin) -> Model
    static func convertModelToRealm(element: Model) -> Origin
    static func convertResultsToModel(results: Results<Origin>) -> [Model]
    static func convertModelsToRealm(elements: [Model]) -> [Origin]
    
}

public class RealmObject {
    
    
    static func convertToModel<T: RealmObjectConverter>(element: T.Origin, type: T.Type) -> T.Model {
        let mirror = Mirror(reflecting: element)
        let target = T.Model()
        
        // for some reason the mirror of a RealmObject doesn't work fine, need to use "value" of object instead
        for case let (label?, _) in mirror.children {
            target.setValue(element.value(forKey: label), forKey: label)
        }
        return target
    }
    
    static func convertModelToRealm<T: RealmObjectConverter>(element: T.Model, type: T.Type) -> T.Origin {
        let mirror = Mirror(reflecting: element)
        let target = T.Origin()
        
        // for some reason the mirror of a RealmObject doesn't work fine, need to use "value" of object instead
        for case let (label?, value) in mirror.children {
            target.setValue(value, forKey: label)
        }
        return target
    }
    
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
