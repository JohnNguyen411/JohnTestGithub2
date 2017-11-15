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
    
    var id: Int
    var text: String
    var state: StepState = .todo
    
    convenience init(text: String, state: StepState) {
        self.init(text: text)
        self.state = state
    }
    
    init(text: String) {
        self.text = text
        super.init()
    }
    
}
