//
//  DealershipTimeSlot+Realm.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 12/21/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift

extension DealershipTimeSlot: VolvoRealmProtocol {
    
    internal typealias Realm = DealershipTimeSlotRealm
    internal typealias Model = DealershipTimeSlot
    
    func toRealmObject() -> DealershipTimeSlotRealm {
        return Realm.convertModelToRealm(element: self)
    }
    
    func toRealm() -> Object {
        return toRealmObject()
    }
    
    static func fromRealm(realmObject: DealershipTimeSlotRealm) -> DealershipTimeSlot {
        return Realm.convertToModel(element: realmObject)
    }
}


@objcMembers class DealershipTimeSlotRealm: Object, RealmObjectConverter {
    
    typealias Model = DealershipTimeSlot
    typealias Realm = DealershipTimeSlotRealm
    
    dynamic var id: Int = -1
    dynamic var dealershipId: Int = -1
    dynamic var type: String?
    dynamic var from: Date?
    dynamic var to: Date?
    dynamic var createdAt: Date?
    dynamic var updatedAt: Date?
    dynamic var availableLoanerVehicleCount = RealmOptional<Int>()
    dynamic var availableAssignmentCount = RealmOptional<Int>()
    
    // we implement that method to ignore values that we don't want to store in Realm
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        // ignore
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func toModel() -> NSObject {
        return DealershipTimeSlotRealm.convertToModel(element: self)
    }
    
    static func convertToModel(element: DealershipTimeSlotRealm) -> DealershipTimeSlot {
        return RealmObject.convertToModel(element: element, type: self, realmType: self)
    }
    
    static func convertModelToRealm(element: DealershipTimeSlot) -> DealershipTimeSlotRealm {
        return RealmObject.convertModelToRealm(element: element, type: self, realmType: self)
    }
    
    static func convertResultsToModel(results: Results<DealershipTimeSlotRealm>) -> [DealershipTimeSlot] {
        return RealmObject.convertResultsToModel(results: results, type: self)
    }
    
    static func convertModelsToRealm(elements: [DealershipTimeSlot]) -> [DealershipTimeSlotRealm] {
        return RealmObject.convertModelsToRealm(elements: elements, type: self)
    }
    
}
