//
//  BookingFeedback+Realm.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 12/21/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift

extension BookingFeedback: VolvoRealmProtocol {
    
    public typealias Realm = BookingFeedbackRealm
    public typealias Model = BookingFeedback
    
    func toRealmObject() -> BookingFeedbackRealm {
        return Realm.convertModelToRealm(element: self)
    }
    
    func toRealm() -> Object {
        return toRealmObject()
    }
    
    static func fromRealm(realmObject: BookingFeedbackRealm) -> BookingFeedback {
        return Realm.convertToModel(element: realmObject)
    }
    
}


@objcMembers class BookingFeedbackRealm: Object, RealmObjectConverter {
    
    typealias Model = BookingFeedback
    typealias Origin = BookingFeedbackRealm
    
    @objc dynamic var baseColor: String?
    @objc dynamic var color: String?
    
    convenience init(baseColor: String?, color: String?) {
        self.init()
        self.baseColor = baseColor
        self.color = color
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func toModel() -> NSObject {
        return BookingFeedbackRealm.convertToModel(element: self)
    }
    
    static func convertToModel(element: BookingFeedbackRealm) -> BookingFeedback {
        return RealmObject.convertToModel(element: element, type: self, realmType: self)
    }
    
    static func convertModelToRealm(element: BookingFeedback) -> BookingFeedbackRealm {
        return RealmObject.convertModelToRealm(element: element, type: self, realmType: self)
    }
    
    static func convertResultsToModel(results: Results<BookingFeedbackRealm>) -> [BookingFeedback] {
        return RealmObject.convertResultsToModel(results: results, type: self)
    }
    
    static func convertModelsToRealm(elements: [BookingFeedback]) -> [BookingFeedbackRealm] {
        return RealmObject.convertModelsToRealm(elements: elements, type: self)
    }
    
}
