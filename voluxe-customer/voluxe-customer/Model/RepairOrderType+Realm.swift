//
//  RepairOrderType+Realm.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 12/13/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

extension RepairOrderType: VolvoRealmProtocol {
    
    public typealias Origin = RepairOrderTypeRealm
    public typealias Target = RepairOrderType
    
    func toRealmObject() -> RepairOrderTypeRealm {
        return Origin.convertModelToRealm(element: self)
    }
    
}


@objcMembers class RepairOrderTypeRealm: Object, RealmObjectConverter {
    
    typealias Target = RepairOrderType
    typealias Origin = RepairOrderTypeRealm
    
    dynamic var id: Int = -1
    dynamic var name: String?
    dynamic var desc: String = ""
    dynamic var category: String?
    dynamic var createdAt: Date?
    dynamic var updatedAt: Date?
    
    convenience init(repairOrder: RepairOrderType) {
        self.init()
        self.id = repairOrder.id
        self.name = repairOrder.name
        self.desc = repairOrder.desc
        self.category = repairOrder.category
        self.createdAt = repairOrder.createdAt
        self.updatedAt = repairOrder.updatedAt
    }
  
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
    static func convertToModel(element: RepairOrderTypeRealm) -> RepairOrderType {
        let repairOrderType = RepairOrderType()
        repairOrderType.id = element.id
        repairOrderType.name = element.name
        repairOrderType.desc = element.desc
        repairOrderType.category = element.category
        repairOrderType.createdAt = element.createdAt
        repairOrderType.updatedAt = element.updatedAt
        return repairOrderType
    }
    
    static func convertResultsToModel(results: Results<RepairOrderTypeRealm>) -> [RepairOrderType] {
        var convertedElements: [RepairOrderType] = []
        
        results.forEach{element in
            convertedElements.append(convertToModel(element: element))
        }
        return convertedElements
    }
    
    static func convertModelsToRealm(elements: [RepairOrderType]) -> [RepairOrderTypeRealm] {
        var convertedElements: [RepairOrderTypeRealm] = []
        
        elements.forEach{element in
            convertedElements.append(RepairOrderTypeRealm(repairOrder: element))
        }
        return convertedElements
    }
    
    static func convertModelToRealm(element: RepairOrderType) -> RepairOrderTypeRealm {
        return RepairOrderTypeRealm(repairOrder: element)
    }
    
    
    
}
