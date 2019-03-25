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
    
    internal func add<Element: VolvoRealmProtocol>(_ object: Element, update: Bool = false) {
        if let realmObject = object.toRealmObject() as? Object {
            self.add(realmObject, update: update)
        }
    }
    
    internal func add<Element: VolvoRealmProtocol>(_ objects: [Element], update: Bool = false) {
        for element in objects {
            if let realmObject = element.toRealmObject() as? Object {
                self.add(realmObject, update: update)
            }
        }
    }
    
    internal func objects<Element: VolvoRealmProtocol>(_ type: Element.Type, _ predicateFormat: String, _ args: Any..., sortedByKeyPath: String? = nil, sortAscending: Bool = false) -> [Element.Realm.Model] {
        return objects(type, predicate: NSPredicate(format: predicateFormat,
                                                    argumentArray: args),
                       sortedByKeyPath: sortedByKeyPath, sortAscending: sortAscending)
    }
    
    internal func objects<Element: VolvoRealmProtocol>(_ type: Element.Type, predicate: NSPredicate? = nil, sortedByKeyPath: String? = nil, sortAscending: Bool = false) -> [Element.Realm.Model] {
        var elements: Results<Element.Realm.Realm>
        if let predicate = predicate {
            elements = self.objects(type.Realm.Realm.self).filter(predicate)
        } else {
            elements = self.objects(type.Realm.Realm.self)
        }
        
        if let sortedByKeyPath = sortedByKeyPath {
            elements = elements.sorted(byKeyPath: sortedByKeyPath, ascending: sortAscending)
        }
        
        return type.Realm.convertResultsToModel(results: elements)
    }
    
    
    internal func deleteFirst<Element: VolvoRealmProtocol>(_ type: Element.Type, _ predicateFormat: String, _ args: Any...) {
        if let object = self.objects(type.Realm.Realm.self).filter(NSPredicate(format: predicateFormat,
                                                                               argumentArray: args)).first {
            self.delete(object)
        }
    }
    
    internal func delete<Element: VolvoRealmProtocol>(_ type: Element.Type, _ predicateFormat: String, _ args: Any...) {
        let objects = self.objects(type.Realm.Realm.self).filter(NSPredicate(format: predicateFormat,
                                                                             argumentArray: args))
        self.delete(objects)
    }
    
    internal func deleteFirst<Element: VolvoRealmProtocol>(_ type: Element.Type, predicate: NSPredicate) {
        if let object = self.objects(type.Realm.Realm.self).filter(predicate).first {
            self.delete(object)
        }
    }
    
    internal func delete<Element: VolvoRealmProtocol>(_ type: Element.Type, predicate: NSPredicate) {
        let objects = self.objects(type.Realm.Realm.self).filter(predicate)
        self.delete(objects)
    }
    
    
    internal func delete<Element: VolvoRealmProtocol>(_ object: Element) {
        if let primaryKey = Element.Realm.Realm.primaryKey() {
            guard let keyValueObject = object as? NSObject else { return }
            guard let primaryKeyValue = keyValueObject.value(forKey: primaryKey) else { return }
            if let object = self.object(ofType: Element.Realm.Realm.self, forPrimaryKey: primaryKeyValue) {
                self.delete(object)
            }
        }
    }
    
    internal func deleteAll<Element: VolvoRealmProtocol>(_ type: Element.Type) {
        let objects = self.objects(type.Realm.Realm.self)
        self.delete(objects)
    }

}
