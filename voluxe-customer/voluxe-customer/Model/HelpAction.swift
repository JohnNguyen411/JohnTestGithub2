//
//  HelpAction.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 6/25/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class HelpAction {

    public enum ActionType {
        case call
        case email
        case webview
    }
    
    var title: String
    var type: ActionType
    var value: String //phone number or email address
    
    init(title: String, type: ActionType, value: String) {
        self.title = title
        self.type = type
        self.value = value
    }
    
}


