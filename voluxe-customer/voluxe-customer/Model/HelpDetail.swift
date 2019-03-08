//
//  HelpDetail.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 6/25/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class HelpDetail {
    
    var title: Localized
    var description: Localized
    var actions: [HelpAction]?
    
    init(title: Localized, description: Localized, actions: [HelpAction]? = nil) {
        self.title = title
        self.description = description
        self.actions = actions
    }
    
    
    
}
