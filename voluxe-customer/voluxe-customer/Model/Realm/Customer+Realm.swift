//
//  Customer+Realm.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 12/20/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift

extension Customer: VolvoRealmProtocol {
    
    public typealias Realm = CustomerRealm
    public typealias Model = Customer
    
    func toRealmObject() -> CustomerRealm {
        return Realm.convertModelToRealm(element: self)
    }
    
    func toRealm() -> Object {
        return toRealmObject()
    }
    
    static func fromRealm(realmObject: CustomerRealm) -> Customer {
        return Realm.convertToModel(element: realmObject)
    }
}


@objcMembers class CustomerRealm: Object, RealmObjectConverter {
    
    typealias Model = Customer
    typealias Realm = CustomerRealm
    
    dynamic var id: Int = -1
    dynamic var volvoCustomerId: String?
    dynamic var email: String?
    dynamic var firstName: String?
    dynamic var lastName: String?
    dynamic var marketCode: String?
    dynamic var phoneNumber: String?
    dynamic var phoneNumberVerified: Bool = false
    dynamic var passwordResetRequired: Bool = false
    dynamic var credit = RealmOptional<Int>()
    dynamic var currencyId = RealmOptional<Int>()
    dynamic var photoUrl: String?
    dynamic var enabled: Bool = true
    dynamic var location: LocationRealm?
    dynamic var createdAt: Date?
    dynamic var updatedAt: Date?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func toModel() -> NSObject {
        return CustomerRealm.convertToModel(element: self)
    }
    
    static func convertToModel(element: CustomerRealm) -> Customer {
        return RealmObject.convertToModel(element: element, type: self, realmType: self)
    }
    
    static func convertModelToRealm(element: Customer) -> CustomerRealm {
        return RealmObject.convertModelToRealm(element: element, type: self, realmType: self)
    }
    
    static func convertResultsToModel(results: Results<CustomerRealm>) -> [Customer] {
        return RealmObject.convertResultsToModel(results: results, type: self)
    }
    
    static func convertModelsToRealm(elements: [Customer]) -> [CustomerRealm] {
        return RealmObject.convertModelsToRealm(elements: elements, type: self)
    }
    
}
