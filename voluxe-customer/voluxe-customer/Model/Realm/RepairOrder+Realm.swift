//
//  RepairOrder+Realm.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 12/21/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift

extension RepairOrder: VolvoRealmProtocol {
    
    internal typealias Realm = RepairOrderRealm
    internal typealias Model = RepairOrder
    
    func toRealmObject() -> RepairOrderRealm {
        return Realm.convertModelToRealm(element: self)
    }
    
    func toRealm() -> Object {
        return toRealmObject()
    }
    
    static func fromRealm(realmObject: RepairOrderRealm) -> RepairOrder {
        return Realm.convertToModel(element: realmObject)
    }
}


@objcMembers class RepairOrderRealm: Object, RealmObjectConverter {
    
    typealias Model = RepairOrder
    typealias Realm = RepairOrderRealm
    
    dynamic var id: Int = -1
    dynamic var bookingId: Int = -1
    dynamic var dealershipRepairOrderId: Int = -1
    dynamic var notes: String = ""
    dynamic var state: String?
    dynamic var vehicleDrivable = RealmOptional<Bool>()
    dynamic var repairOrderType: RepairOrderTypeRealm?
    dynamic var name: String?
    dynamic var title: String?
    dynamic var createdAt: Date?
    dynamic var updatedAt: Date?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func toModel() -> NSObject {
        return RepairOrderRealm.convertToModel(element: self)
    }
    
    static func convertToModel(element: RepairOrderRealm) -> RepairOrder {
        return RealmObject.convertToModel(element: element, type: self, realmType: self)
    }
    
    static func convertModelToRealm(element: RepairOrder) -> RepairOrderRealm {
        return RealmObject.convertModelToRealm(element: element, type: self, realmType: self)
    }
    
    static func convertResultsToModel(results: Results<RepairOrderRealm>) -> [RepairOrder] {
        return RealmObject.convertResultsToModel(results: results, type: self)
    }
    
    static func convertModelsToRealm(elements: [RepairOrder]) -> [RepairOrderRealm] {
        return RealmObject.convertModelsToRealm(elements: elements, type: self)
    }
}
