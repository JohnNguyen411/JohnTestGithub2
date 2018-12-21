//
//  VehicleMake+Realm.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 12/18/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift

extension VehicleMake: VolvoRealmProtocol {
    
    public typealias Realm = VehicleMakeRealm
    public typealias Model = VehicleMake
    
    func toRealmObject() -> VehicleMakeRealm {
        return Realm.convertModelToRealm(element: self)
    }
    
    func toRealm() -> Object {
        return toRealmObject()
    }
    
    static func fromRealm(realmObject: VehicleMakeRealm) -> VehicleMake {
        return Realm.convertToModel(element: realmObject)
    }
}


@objcMembers class VehicleMakeRealm: Object, RealmObjectConverter {
    
    typealias Model = VehicleMake
    typealias Realm = VehicleMakeRealm
    
    dynamic var id: Int = -1
    dynamic var name: String?
    dynamic var managed: Bool = true
    dynamic var createdAt: Date?
    dynamic var updatedAt: Date?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func toModel() -> NSObject {
        return VehicleMakeRealm.convertToModel(element: self)
    }
    
    static func convertToModel(element: VehicleMakeRealm) -> VehicleMake {
        return RealmObject.convertToModel(element: element, type: self, realmType: self)
    }
    
    static func convertModelToRealm(element: VehicleMake) -> VehicleMakeRealm {
        return RealmObject.convertModelToRealm(element: element, type: self, realmType: self)
    }
    
    static func convertResultsToModel(results: Results<VehicleMakeRealm>) -> [VehicleMake] {
        return RealmObject.convertResultsToModel(results: results, type: self)
    }
    
    static func convertModelsToRealm(elements: [VehicleMake]) -> [VehicleMakeRealm] {
        return RealmObject.convertModelsToRealm(elements: elements, type: self)
    }
    
}
