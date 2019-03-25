//
//  Vehicle+Realm.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 12/20/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift

extension Vehicle: VolvoRealmProtocol {
    
    internal typealias Realm = VehicleRealm
    internal typealias Model = Vehicle
    
    func toRealmObject() -> VehicleRealm {
        return Realm.convertModelToRealm(element: self)
    }
    
    func toRealm() -> Object {
        return toRealmObject()
    }
    
    static func fromRealm(realmObject: VehicleRealm) -> Vehicle {
        return Realm.convertToModel(element: realmObject)
    }
}


@objcMembers class VehicleRealm: Object, RealmObjectConverter {
    
    typealias Model = Vehicle
    typealias Realm = VehicleRealm
    
    dynamic var id: Int = -1
    dynamic var vin: String?
    dynamic var licensePlate: String?
    dynamic var make: String?
    dynamic var model: String?
    dynamic var drive: String?
    dynamic var engine: String?
    dynamic var trim: String?
    dynamic var year: Int = 2018
    dynamic var baseColor: String?
    dynamic var color: String?
    dynamic var photoUrl: String?
    dynamic var transmission: String?
    dynamic var createdAt: Date?
    dynamic var updatedAt: Date?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func toModel() -> NSObject {
        return VehicleRealm.convertToModel(element: self)
    }
    
    static func convertToModel(element: VehicleRealm) -> Vehicle {
        return RealmObject.convertToModel(element: element, type: self, realmType: self)
    }
    
    static func convertModelToRealm(element: Vehicle) -> VehicleRealm {
        return RealmObject.convertModelToRealm(element: element, type: self, realmType: self)
    }
    
    static func convertResultsToModel(results: Results<VehicleRealm>) -> [Vehicle] {
        return RealmObject.convertResultsToModel(results: results, type: self)
    }
    
    static func convertModelsToRealm(elements: [Vehicle]) -> [VehicleRealm] {
        return RealmObject.convertModelsToRealm(elements: elements, type: self)
    }
    
}
