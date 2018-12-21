//
//  Driver+Realm.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 12/21/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift

extension Driver: VolvoRealmProtocol {
    
    public typealias Realm = DriverRealm
    public typealias Model = Driver
    
    func toRealmObject() -> DriverRealm {
        return Realm.convertModelToRealm(element: self)
    }
    
    func toRealm() -> Object {
        return toRealmObject()
    }
    
    static func fromRealm(realmObject: DriverRealm) -> Driver {
        return Realm.convertToModel(element: realmObject)
    }
}


@objcMembers class DriverRealm: Object, RealmObjectConverter {
    
    typealias Model = Driver
    typealias Realm = DriverRealm
    
    dynamic var id: Int = -1
    dynamic var name: String?
    dynamic var iconUrl: String?
    dynamic var location: LocationRealm?
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func toModel() -> NSObject {
        return DriverRealm.convertToModel(element: self)
    }
    
    static func convertToModel(element: DriverRealm) -> Driver {
        return RealmObject.convertToModel(element: element, type: self, realmType: self)
    }
    
    static func convertModelToRealm(element: Driver) -> DriverRealm {
        return RealmObject.convertModelToRealm(element: element, type: self, realmType: self)
    }
    
    static func convertResultsToModel(results: Results<DriverRealm>) -> [Driver] {
        return RealmObject.convertResultsToModel(results: results, type: self)
    }
    
    static func convertModelsToRealm(elements: [Driver]) -> [DriverRealm] {
        return RealmObject.convertModelsToRealm(elements: elements, type: self)
    }
    
}
