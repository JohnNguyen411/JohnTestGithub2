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
    
    associatedtype T // The model object
    associatedtype E: Object // the Realm Object
    
    static func convertToModel(element: E) -> T
    static func convertModelToRealm(element: T) -> E
    static func convertResultsToModel(results: Results<E>) -> [T]
    static func convertModelsToRealm(elements: [T]) -> [E]
    
}
