//
//  Step.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/15/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

public enum StepState {
    case todo
    case done
}

class Step: NSObject {
    
    var id: ServiceState
    var text: String
    var state: StepState = .todo
    
    convenience init(id: ServiceState, text: String, state: StepState) {
        self.init(id: id, text: text)
        self.state = state
    }
    
    init(id: ServiceState, text: String) {
        self.id = id
        self.text = text
        super.init()
    }
    
}
