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
    
    public typealias Origin = CustomerAddressRealm
    public typealias Model = CustomerAddress
    
    func toRealmObject() -> CustomerAddressRealm {
        return Origin.convertModelToRealm(element: self)
    }
    
    func toRealm() -> Object {
        return toRealmObject()
    }
    
}


@objcMembers class CustomerAddressRealm: Object, RealmObjectConverter {
    
    typealias Model = CustomerAddress
    typealias Origin = CustomerAddressRealm
    
    dynamic var id = UUID().uuidString
    dynamic var volvoCustomerId: String?
    dynamic var location: LocationRealm?
    dynamic var label: String? // Work / Home / Gym etc
    dynamic var createdAt: Date?
    dynamic var updatedAt: Date?
    dynamic var luxeCustomerId: Int = -1
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    public static func modelToRealmProperties() -> [String: NSObject.Type]? {
        return ["location": LocationRealm.self]
    }
    
    public static func realmToModelProperties() -> [String: NSObject.Type]? {
        return ["location": Location.self]
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
