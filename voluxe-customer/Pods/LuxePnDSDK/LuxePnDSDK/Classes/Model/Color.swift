//
//  Color.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 3/1/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

public class Color: NSObject, Codable {
    
    public var baseColor: String?
    public var color: String?
    
    public convenience init(baseColor: String?, color: String?) {
        self.init()
        self.baseColor = baseColor
        self.color = color
    }
    
}
