//
//  Realm+Model.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 12/14/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift

extension Realm {
    
    public func add<Element: VolvoRealmProtocol>(_ object: Element, update: Bool = false) {
        if let realmObject = object.toRealmObject() as? Object {
            self.add(realmObject, update: update)
        }
    }
    
    public func add<Element: VolvoRealmProtocol>(_ objects: [Element], update: Bool = false) {
        for element in objects {
            if let realmObject = element.toRealmObject() as? Object {
                self.add(realmObject, update: update)
            }
        }
    }
    
    public func objects<Element: VolvoRealmProtocol>(_ type: Element.Type, predicate: String? = nil, sortedByKeyPath: String? = nil, sortAscending: Bool = false) -> [Element.Origin.Model] {
        var elements: Results<Element.Origin.Origin>
        if let predicate = predicate {
            elements = self.objects(type.Origin.Origin.self).filter(predicate)
        } else {
            elements = self.objects(type.Origin.Origin.self)
        }
        
        if let sortedByKeyPath = sortedByKeyPath {
            elements = elements.sorted(byKeyPath: sortedByKeyPath, ascending: sortAscending)
        }
        
        return type.Origin.convertResultsToModel(results: elements)
    }
    
    public func deleteFirst<Element: VolvoRealmProtocol>(_ type: Element.Type, predicate: String) {
        if let object = self.objects(type.Origin.Origin.self).filter(predicate).first {
            self.delete(object)
        }
    }
    
    public func delete<Element: VolvoRealmProtocol>(_ type: Element.Type, predicate: String) {
        let objects = self.objects(type.Origin.Origin.self).filter(predicate)
        self.delete(objects)
    }
    
    public func deleteAll<Element: VolvoRealmProtocol>(_ type: Element.Type) {
        let objects = self.objects(type.Origin.Origin.self)
        self.delete(objects)
    }

}
