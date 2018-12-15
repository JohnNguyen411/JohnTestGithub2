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
    
    public typealias Origin = ColorRealm
    public typealias Model = Color
    
    func toRealmObject() -> ColorRealm {
        return Origin.convertModelToRealm(element: self)
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
    
    static func convertToModel(element: ColorRealm) -> Color {
        return Color(baseColor: element.baseColor, color: element.color)
    }
    
    static func convertModelToRealm(element: Color) -> ColorRealm {
        return ColorRealm(baseColor: element.baseColor, color: element.color)
    }
    
    static func convertResultsToModel(results: Results<ColorRealm>) -> [Color] {
        var convertedElements: [Color] = []
        
        results.forEach{element in
            convertedElements.append(convertToModel(element: element))
        }
        return convertedElements
    }
    
    static func convertModelsToRealm(elements: [Color]) -> [ColorRealm] {
        var convertedElements: [ColorRealm] = []
        
        elements.forEach{element in
            convertedElements.append(convertModelToRealm(element: element))
        }
        return convertedElements
    }
    
    

}
