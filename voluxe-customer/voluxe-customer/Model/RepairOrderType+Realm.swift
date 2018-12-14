//
//  RepairOrderType+Realm.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 12/13/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

extension RepairOrderType: VolvoRealmProtocol {
    
    typealias T = RepairOrderType
    
    func add(_ realm: Realm, update: Bool = true) {
        try? realm.write {
            realm.add(RepairOrderTypeRealm(repairOrder: self), update: update)
        }
    }
    
    static func add(_ realm: Realm, objects: [RepairOrderType], update: Bool = true) {
        try? realm.write {
            let elements = RepairOrderTypeRealm.convertModelToRealm(elements: objects)
            realm.add(elements, update: update)
        }
    }
    
    
    func delete(_ realm: Realm) {
        try? realm.write {
            if let object = realm.objects(RepairOrderTypeRealm.self).filter("id == \(self.id)").first {
                realm.delete(object)
            }
        }
    }
    
    static func delete(_ realm: Realm, objects: [RepairOrderType]) {
        try? realm.write {
            //TODO: Actually implement it ...
        }
    }
    
    static func deleteAll(_ realm: Realm) {
        try? realm.write {
            let allObjects = realm.objects(RepairOrderTypeRealm.self)
            realm.delete(allObjects)
        }
    }
    

    static func objects(_ realm: Realm, predicate: String? = nil) -> [RepairOrderType] {
        if let predicate = predicate {
            let elements = realm.objects(RepairOrderTypeRealm.self).filter(predicate)
            return RepairOrderTypeRealm.convertResultsToModel(results: elements)
        } else {
            let elements = realm.objects(RepairOrderTypeRealm.self)
            return RepairOrderTypeRealm.convertResultsToModel(results: elements)
        }
    }
}


@objcMembers class RepairOrderTypeRealm: Object, RealmObjectConverter {
    
    typealias T = RepairOrderType
    typealias E = RepairOrderTypeRealm
    
    
    dynamic var id: Int = -1
    dynamic var name: String?
    dynamic var desc: String = ""
    dynamic var category: String?
    dynamic var createdAt: Date?
    dynamic var updatedAt: Date?
    
    convenience init(repairOrder: RepairOrderType) {
        self.init()
        self.id = repairOrder.id
        self.name = repairOrder.name
        self.desc = repairOrder.desc
        self.category = repairOrder.category
        self.createdAt = repairOrder.createdAt
        self.updatedAt = repairOrder.updatedAt
    }
  
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
    static func convertToModel(element: RepairOrderTypeRealm) -> RepairOrderType {
        let repairOrderType = RepairOrderType()
        repairOrderType.id = element.id
        repairOrderType.name = element.name
        repairOrderType.desc = element.desc
        repairOrderType.category = element.category
        repairOrderType.createdAt = element.createdAt
        repairOrderType.updatedAt = element.updatedAt
        return repairOrderType
    }
    
    static func convertResultsToModel(results: Results<RepairOrderTypeRealm>) -> [RepairOrderType] {
        var convertedElements: [RepairOrderType] = []
        
        results.forEach{element in
            convertedElements.append(convertToModel(element: element))
        }
        return convertedElements
    }
    
    static func convertModelToRealm(elements: [RepairOrderType]) -> [RepairOrderTypeRealm] {
        var convertedElements: [RepairOrderTypeRealm] = []
        
        elements.forEach{element in
            convertedElements.append(RepairOrderTypeRealm(repairOrder: element))
        }
        return convertedElements
    }
    
    
}
