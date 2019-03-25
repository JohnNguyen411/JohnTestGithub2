//
//  Location+Realm.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 12/18/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift

extension Location: VolvoRealmProtocol {
    
    internal typealias Realm = LocationRealm
    internal typealias Model = Location
    
    func toRealmObject() -> LocationRealm {
        return Realm.convertModelToRealm(element: self)
    }
    
    func toRealm() -> Object {
        return toRealmObject()
    }
    
    static func fromRealm(realmObject: LocationRealm) -> Location {
        return Realm.convertToModel(element: realmObject)
    }
}


@objcMembers class LocationRealm: Object, RealmObjectConverter {
    
    typealias Model = Location
    typealias Realm = LocationRealm
    
    dynamic var id = UUID().uuidString
    dynamic var address: String?
    dynamic var latitude: Double = 0.0
    dynamic var longitude: Double = 0.0
    dynamic var accuracy = RealmOptional<Double>()
    dynamic var createdAt: Date?
    dynamic var updatedAt: Date?
    dynamic var location: CLLocationCoordinate2D?
    
    override static func ignoredProperties() -> [String] {
        return ["location"]
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func toModel() -> NSObject {
        return LocationRealm.convertToModel(element: self)
    }
    
    static func modelToRealmProperties() -> [String : NSObject.Type]? {
        return nil
    }
    
    static func realmToModelProperties() -> [String : NSObject.Type]? {
        return nil
    }
    
    static func convertToModel(element: LocationRealm) -> Location {
        return RealmObject.convertToModel(element: element, type: self, realmType: self)
    }
    
    static func convertModelToRealm(element: Location) -> LocationRealm {
        return RealmObject.convertModelToRealm(element: element, type: self, realmType: self)
    }
    
    static func convertResultsToModel(results: Results<LocationRealm>) -> [Location] {
        return RealmObject.convertResultsToModel(results: results, type: self)
    }
    
    static func convertModelsToRealm(elements: [Location]) -> [LocationRealm] {
        return RealmObject.convertModelsToRealm(elements: elements, type: self)
    }
    
}
