//
//  RealmObjectConverter.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 12/14/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift

public protocol RealmObjectConverter: ConverterHelper {
    
    associatedtype Model: NSObject // The model object, need
    associatedtype Realm: Object // the Realm Object
    
    static func convertToModel(element: Realm) -> Model
    static func convertModelToRealm(element: Model) -> Realm
    static func convertResultsToModel(results: Results<Realm>) -> [Model]
    static func convertModelsToRealm(elements: [Model]) -> [Realm]

}

public protocol ConverterHelper {
    func toModel() -> NSObject

}

public class RealmObject {
    
    static func convertToModel<T: RealmObjectConverter, O: Object>(element: T.Realm, type: T.Type, realmType: O.Type) -> T.Model {
        let mirror = Mirror(reflecting: element)
        let target = T.Model()
        
        let ignoredProperties = realmType.ignoredProperties()

        
        // for some reason the mirror of a RealmObject doesn't work fine, need to use "value" of object instead
        for child in mirror.children {
            guard let label = child.label else { continue }
            
            // make sure to skip ignored properties
            if ignoredProperties.contains(label) { continue }
            
            let elementValue = element.value(forKey: label)
                
            if case Optional<Any>.some(_) = elementValue {
                if let object = elementValue as? NSObject,  let model = object as? ConverterHelper {
                    target.setValue(model.toModel(), forKey: label)
                } else {
                    
                    let childMirror = Mirror(reflecting: child.value)
                    let subjectType = childMirror.subjectType
                    
                    target.setValue(convertListValue(elementValue, subjectType: subjectType), forKey: label)
                    
                }
            } else {
                target.setValue(nil, forKey: label)
            }
        }
        return target
    }
    
    static func convertModelToRealm<T: RealmObjectConverter, O: Object>(element: T.Model, type: T.Type, realmType: O.Type) -> T.Realm {
        let mirror = Mirror(reflecting: element)
        let target = T.Realm()
        
        let ignoredProperties = realmType.ignoredProperties()
                
        for case let (label?, value) in mirror.children {
            
            // make sure to skip ignored properties
            if ignoredProperties.contains(label) { continue }
            
            if case Optional<Any>.some(_) = value {
                if let object = value as? NSObject,  let model = object as? ToRealmProtocol {
                    target.setValue(model.toRealm(), forKey: label)
                } else {
                    target.setValue(value, forKey: label)
                }
            } else {
                target.setValue(nil, forKey: label)
            }
        }
        return target
    }
    
    static func convertResultsToModel<T: RealmObjectConverter>(results: Results<T.Realm>, type: T.Type) -> [T.Model] {
        var convertedElements: [T.Model] = []
        results.forEach { element in
            convertedElements.append(type.convertToModel(element: element))
        }
        
        return convertedElements
    }
    
    static func convertModelsToRealm<T: RealmObjectConverter>(elements: [T.Model], type: T.Type) -> [T.Realm] {
        var convertedElements: [T.Realm] = []
        elements.forEach { element in
            convertedElements.append(type.convertModelToRealm(element: element))
        }
        
        return convertedElements
    }
    
    private static func convertListValue(_ elementValue: Any?, subjectType: Any.Type) -> Any? {
        if subjectType is List<RepairOrderRealm>.Type {
            if let repairOrdersRealm = elementValue as? List<RepairOrderRealm> {
                return convertValues(repairOrdersRealm, type: RepairOrderRealm.self)
            }
        } else {
            return elementValue
        }
        return nil
    }
    
    private static func convertValues<T: RealmObjectConverter>(_ values: List<T>, type: T.Type) -> Any? {
        var repairOrders: [T.Model] = []
        for repairOrderRealm in values {
            if let repairOrderR = repairOrderRealm as? T.Realm {
                repairOrders.append(T.convertToModel(element: repairOrderR))
            }
        }
        return repairOrders
    }
    
    private static func newOptionalValue(type: Any.Type) -> Any? {
        if type is RealmOptional<Int>.Type {
            return RealmOptional<Int>()
        } else if type is RealmOptional<Int8>.Type {
            return RealmOptional<Int8>()
        } else if type is RealmOptional<Int16>.Type {
            return RealmOptional<Int16>()
        } else if type is RealmOptional<Int32>.Type {
            return RealmOptional<Int32>()
        } else if type is RealmOptional<Int64>.Type {
            return RealmOptional<Int64>()
        } else if type is RealmOptional<Float>.Type{
            return RealmOptional<Float>()
        } else if type is RealmOptional<Double>.Type{
            return RealmOptional<Double>()
        } else if type is RealmOptional<Bool>.Type{
            return RealmOptional<Bool>()
        }
        return nil
    }
    
    private static func isRealmOptional(type: Any.Type) -> Bool {
        if type is RealmOptional<Int>.Type ||
            type is RealmOptional<Int8>.Type ||
            type is RealmOptional<Int16>.Type ||
            type is RealmOptional<Int32>.Type ||
            type is RealmOptional<Int64>.Type ||
            type is RealmOptional<Float>.Type ||
            type is RealmOptional<Double>.Type ||
            type is RealmOptional<Bool>.Type {
            return true
        }
        return false
    }
    
}
