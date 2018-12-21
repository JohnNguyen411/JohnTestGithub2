//
//  Color+Realm.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 12/14/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift

extension Color: VolvoRealmProtocol {
    
    public typealias Realm = ColorRealm
    public typealias Model = Color
    
    func toRealmObject() -> ColorRealm {
        return Realm.convertModelToRealm(element: self)
    }
    
    func toRealm() -> Object {
        return toRealmObject()
    }
    
    static func fromRealm(realmObject: ColorRealm) -> Color {
        return Realm.convertToModel(element: realmObject)
    }
    
}


@objcMembers class ColorRealm: Object, RealmObjectConverter {
    
    typealias Model = Color
    typealias Origin = ColorRealm

    @objc dynamic var baseColor: String?
    @objc dynamic var color: String?
    
    convenience init(baseColor: String?, color: String?) {
        self.init()
        self.baseColor = baseColor
        self.color = color
    }
    
    override static func primaryKey() -> String? {
        return "baseColor"
    }
    
    func toModel() -> NSObject {
        return ColorRealm.convertToModel(element: self)
    }
    
    static func convertToModel(element: ColorRealm) -> Color {
        return RealmObject.convertToModel(element: element, type: self, realmType: self)
    }
    
    static func convertModelToRealm(element: Color) -> ColorRealm {
        return RealmObject.convertModelToRealm(element: element, type: self, realmType: self)
    }
    
    static func convertResultsToModel(results: Results<ColorRealm>) -> [Color] {
        return RealmObject.convertResultsToModel(results: results, type: self)
    }
    
    static func convertModelsToRealm(elements: [Color]) -> [ColorRealm] {
        return RealmObject.convertModelsToRealm(elements: elements, type: self)
    }
    
}
