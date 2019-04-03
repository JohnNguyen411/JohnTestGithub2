//
//  Dealership+Realm.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 12/21/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift

extension Dealership: VolvoRealmProtocol {
    
    typealias Realm = DealershipRealm
    typealias Model = Dealership
    
    func toRealmObject() -> DealershipRealm {
        return Realm.convertModelToRealm(element: self)
    }
    
    func toRealm() -> Object {
        return toRealmObject()
    }
    
    static func fromRealm(realmObject: DealershipRealm) -> Dealership {
        return Realm.convertToModel(element: realmObject)
    }
}


@objcMembers class DealershipRealm: Object, RealmObjectConverter {
    
    typealias Model = Dealership
    typealias Realm = DealershipRealm
    
    dynamic var id: Int = -1
    dynamic var name: String?
    dynamic var phoneNumber: String?
    dynamic var email: String?
    dynamic var location: LocationRealm?
    dynamic var hoursOfOperation: String?
    dynamic var coverageRadius: Int = 1
    dynamic var currencyId = RealmOptional<Int>()
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
        return DealershipRealm.convertToModel(element: self)
    }
    
    static func convertToModel(element: DealershipRealm) -> Dealership {
        return RealmObject.convertToModel(element: element, type: self, realmType: self)
    }
    
    static func convertModelToRealm(element: Dealership) -> DealershipRealm {
        return RealmObject.convertModelToRealm(element: element, type: self, realmType: self)
    }
    
    static func convertResultsToModel(results: Results<DealershipRealm>) -> [Dealership] {
        return RealmObject.convertResultsToModel(results: results, type: self)
    }
    
    static func convertModelsToRealm(elements: [Dealership]) -> [DealershipRealm] {
        return RealmObject.convertModelsToRealm(elements: elements, type: self)
    }
    
}
