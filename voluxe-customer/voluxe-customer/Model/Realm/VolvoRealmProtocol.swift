//
//  VolvoRealmProtocol.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 12/13/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

public protocol VolvoRealmProtocol: ToRealmProtocol {
    
    associatedtype Realm: RealmObjectConverter // the Realm Object
    associatedtype Model // The model object

    func toRealmObject() -> Realm
    static func fromRealm(realmObject: Realm) -> Model

}

public protocol ToRealmProtocol {
    func toRealm() -> Object
}
