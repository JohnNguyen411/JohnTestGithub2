//
//  HelpSection.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 6/27/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class HelpSection {
    
    public enum HelpType {
        case booking
        case product
        case app
    }
    
    var title: String
    var type: HelpType
    var sections: [HelpDetail]
    
    init(title: String, type: HelpType, sections: [HelpDetail]) {
        self.title = title
        self.type = type
        self.sections = sections
    }
}
