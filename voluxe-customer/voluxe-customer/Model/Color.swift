//
//  Color.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 3/1/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class Color: Object, Mappable {
    
    @objc dynamic var baseColor: String?
    @objc dynamic var color: String?
    
    convenience init(baseColor: String?, color: String?) {
        self.init()
        self.baseColor = baseColor
        self.color = color
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        baseColor <- map["base_color"]
        color <- map["color"]
    }
    
    override static func primaryKey() -> String? {
        return "baseColor"
    }
    
}
