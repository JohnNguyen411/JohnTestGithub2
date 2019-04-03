//
//  CustomerAddress+Realm.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 12/19/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift

extension CustomerAddress: VolvoRealmProtocol {
    
    typealias Realm = CustomerAddressRealm
    typealias Model = CustomerAddress
    
    func toRealmObject() -> CustomerAddressRealm {
        return Realm.convertModelToRealm(element: self)
    }
    
    func toRealm() -> Object {
        return toRealmObject()
    }
    
    static func fromRealm(realmObject: CustomerAddressRealm) -> CustomerAddress {
        return Realm.convertToModel(element: realmObject)
    }
}


@objcMembers class CustomerAddressRealm: Object, RealmObjectConverter {
    
    typealias Model = CustomerAddress
    typealias Realm = CustomerAddressRealm
    
    dynamic var id = UUID().uuidString
    dynamic var volvoCustomerId: String?
    dynamic var location: LocationRealm?
    dynamic var label: String? // Work / Home / Gym etc
    dynamic var createdAt: Date?
    dynamic var updatedAt: Date?
    dynamic var luxeCustomerId: Int = -1
    
    // we implement that method to ignore values that we don't want to store in Realm
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        // ignore
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func toModel() -> NSObject {
        return CustomerAddressRealm.convertToModel(element: self)
    }
    
    static func convertToModel(element: CustomerAddressRealm) -> CustomerAddress {
        return RealmObject.convertToModel(element: element, type: self, realmType: self)
    }
    
    static func convertModelToRealm(element: CustomerAddress) -> CustomerAddressRealm {
        return RealmObject.convertModelToRealm(element: element, type: self, realmType: self)
    }
    
    static func convertResultsToModel(results: Results<CustomerAddressRealm>) -> [CustomerAddress] {
        return RealmObject.convertResultsToModel(results: results, type: self)
    }
    
    static func convertModelsToRealm(elements: [CustomerAddress]) -> [CustomerAddressRealm] {
        return RealmObject.convertModelsToRealm(elements: elements, type: self)
    }
    
}
