//
//  DealershipRepairOrder+Realm.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 12/21/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift

extension DealershipRepairOrder: VolvoRealmProtocol {
    
    typealias Realm = DealershipRepairOrderRealm
    typealias Model = DealershipRepairOrder
    
    func toRealmObject() -> DealershipRepairOrderRealm {
        return Realm.convertModelToRealm(element: self)
    }
    
    func toRealm() -> Object {
        return toRealmObject()
    }
    
    static func fromRealm(realmObject: DealershipRepairOrderRealm) -> DealershipRepairOrder {
        return Realm.convertToModel(element: realmObject)
    }
}


@objcMembers class DealershipRepairOrderRealm: Object, RealmObjectConverter {
    
    typealias Model = DealershipRepairOrder
    typealias Realm = DealershipRepairOrderRealm
    
    dynamic var id: Int = -1
    dynamic var dealershipId = -1
    dynamic var repairOrderTypeId = -1
    dynamic var enabled: Bool = true
    dynamic var createdAt: Date?
    dynamic var updatedAt: Date?
    
    // we implement that method to ignore values that we don't want to store in Realm
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        // ignore
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func toModel() -> NSObject {
        return DealershipRepairOrderRealm.convertToModel(element: self)
    }
    
    static func convertToModel(element: DealershipRepairOrderRealm) -> DealershipRepairOrder {
        return RealmObject.convertToModel(element: element, type: self, realmType: self)
    }
    
    static func convertModelToRealm(element: DealershipRepairOrder) -> DealershipRepairOrderRealm {
        return RealmObject.convertModelToRealm(element: element, type: self, realmType: self)
    }
    
    static func convertResultsToModel(results: Results<DealershipRepairOrderRealm>) -> [DealershipRepairOrder] {
        return RealmObject.convertResultsToModel(results: results, type: self)
    }
    
    static func convertModelsToRealm(elements: [DealershipRepairOrder]) -> [DealershipRepairOrderRealm] {
        return RealmObject.convertModelsToRealm(elements: elements, type: self)
    }
    
}
