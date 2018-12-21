//
//  Request+Realm.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 12/21/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift

extension Request: VolvoRealmProtocol {
    
    public typealias Realm = RequestRealm
    public typealias Model = Request
    
    func toRealmObject() -> RequestRealm {
        return Realm.convertModelToRealm(element: self)
    }
    
    func toRealm() -> Object {
        return toRealmObject()
    }
    
    static func fromRealm(realmObject: RequestRealm) -> Request {
        return Realm.convertToModel(element: realmObject)
    }
}


@objcMembers class RequestRealm: Object, RealmObjectConverter {
    
    typealias Model = Request
    typealias Realm = RequestRealm
    
    dynamic var id: Int = -1
    dynamic var bookingId: Int = -1
    dynamic var timeslotId = RealmOptional<Int>()
    dynamic var state: String = "requested"
    dynamic var type: String?
    dynamic var createdAt: Date?
    dynamic var updatedAt: Date?
    dynamic var driver: DriverRealm?
    dynamic var location: LocationRealm?
    dynamic var timeSlot: DealershipTimeSlotRealm?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func toModel() -> NSObject {
        return RequestRealm.convertToModel(element: self)
    }
    
    static func modelToRealmProperties() -> [String : NSObject.Type]? {
        return nil
    }
    
    static func realmToModelProperties() -> [String : NSObject.Type]? {
        return nil
    }
    
    static func convertToModel(element: RequestRealm) -> Request {
        return RealmObject.convertToModel(element: element, type: self, realmType: self)
    }
    
    static func convertModelToRealm(element: Request) -> RequestRealm {
        return RealmObject.convertModelToRealm(element: element, type: self, realmType: self)
    }
    
    static func convertResultsToModel(results: Results<RequestRealm>) -> [Request] {
        return RealmObject.convertResultsToModel(results: results, type: self)
    }
    
    static func convertModelsToRealm(elements: [Request]) -> [RequestRealm] {
        return RealmObject.convertModelsToRealm(elements: elements, type: self)
    }
    
}
