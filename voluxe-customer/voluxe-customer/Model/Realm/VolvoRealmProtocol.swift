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

public protocol VolvoRealmProtocol {
    
    associatedtype Origin: RealmObjectConverter // the Realm Object
    associatedtype Target // The model object

    func toRealmObject() -> Origin

}
