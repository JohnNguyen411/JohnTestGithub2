//
//  VolvoRealmProtocol.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 12/13/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

protocol VolvoRealmProtocol {
    
    associatedtype T

    func add(_ realm: Realm, update: Bool)
    static func add(_ realm: Realm, objects: [T], update: Bool)

    func delete(_ realm: Realm)
    static func delete(_ realm: Realm, objects: [T])
    static func deleteAll(_ realm: Realm)

    static func objects(_ realm: Realm, predicate: String?) -> [T]
    
}

protocol RealmObjectConverter {
    
    associatedtype T
    associatedtype E: Object

    static func convertToModel(element: E) -> T
    static func convertResultsToModel(results: Results<E>) -> [T]
    static func convertModelToRealm(elements: [T]) -> [E]

    
}
