//
//  RepairOrderType+Realm.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 12/13/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift

extension RepairOrderType: VolvoRealmProtocol {
    
    public typealias Origin = RepairOrderTypeRealm
    public typealias Model = RepairOrderType
    
    func toRealmObject() -> RepairOrderTypeRealm {
        return Origin.convertModelToRealm(element: self)
    }
    
    func toRealm() -> Object {
        return toRealmObject()
    }
}


@objcMembers class RepairOrderTypeRealm: Object, RealmObjectConverter {
    
    typealias Target = RepairOrderType
    typealias Origin = RepairOrderTypeRealm
    
    dynamic var id: Int = -1
    dynamic var name: String?
    dynamic var desc: String = ""
    dynamic var category: String?
    dynamic var createdAt: Date?
    dynamic var updatedAt: Date?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func modelToRealmProperties() -> [String : NSObject.Type]? {
        return nil
    }
    
    static func realmToModelProperties() -> [String : NSObject.Type]? {
        return nil
    }
    
    func toModel() -> NSObject {
        return RepairOrderTypeRealm.convertToModel(element: self)
    }
    
    static func convertToModel(element: RepairOrderTypeRealm) -> RepairOrderType {
        return RealmObject.convertToModel(element: element, type: self, realmType: self)
    }
    
    static func convertModelToRealm(element: RepairOrderType) -> RepairOrderTypeRealm {
        return RealmObject.convertModelToRealm(element: element, type: self, realmType: self)
    }
    
    static func convertResultsToModel(results: Results<RepairOrderTypeRealm>) -> [RepairOrderType] {
        return RealmObject.convertResultsToModel(results: results, type: self)
    }
    
    static func convertModelsToRealm(elements: [RepairOrderType]) -> [RepairOrderTypeRealm] {
        return RealmObject.convertModelsToRealm(elements: elements, type: self)
    }
}
