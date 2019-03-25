//
//  VehicleModel+Realm.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 12/18/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift

extension VehicleModel: VolvoRealmProtocol {
    
    typealias Realm = VehicleModelRealm
    typealias Model = VehicleModel
    
    func toRealmObject() -> VehicleModelRealm {
        return Realm.convertModelToRealm(element: self)
    }
    
    func toRealm() -> Object {
        return toRealmObject()
    }
    
    static func fromRealm(realmObject: VehicleModelRealm) -> VehicleModel {
        return Realm.convertToModel(element: realmObject)
    }
}


@objcMembers class VehicleModelRealm: Object, RealmObjectConverter {
    
    typealias Model = VehicleModel
    typealias Realm = VehicleModelRealm
    
    dynamic var id: Int = -1
    dynamic var make: String?
    dynamic var name: String?
    dynamic var managed: Bool = true
    dynamic var createdAt: Date?
    dynamic var updatedAt: Date?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func toModel() -> NSObject {
        return VehicleModelRealm.convertToModel(element: self)
    }
    
    static func convertToModel(element: VehicleModelRealm) -> VehicleModel {
        return RealmObject.convertToModel(element: element, type: self, realmType: self)
    }
    
    static func convertModelToRealm(element: VehicleModel) -> VehicleModelRealm {
        return RealmObject.convertModelToRealm(element: element, type: self, realmType: self)
    }
    
    static func convertResultsToModel(results: Results<VehicleModelRealm>) -> [VehicleModel] {
        return RealmObject.convertResultsToModel(results: results, type: self)
    }
    
    static func convertModelsToRealm(elements: [VehicleModel]) -> [VehicleModelRealm] {
        return RealmObject.convertModelsToRealm(elements: elements, type: self)
    }
    
}
