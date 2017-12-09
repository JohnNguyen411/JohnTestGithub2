//
//  Logger.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 12/8/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

class Logger {
    
    private static var shouldLog = false
    
    init() {
        let bundle = Bundle(for: type(of: self))
        let who = bundle.object(forInfoDictionaryKey: "ENABLE_DEBUG_INFO") as! String
        Logger.shouldLog = who.boolValue
    }
}

extension Logger {
    
    static func print(_ string: String) {
        if Logger.shouldLog {
            Swift.print(string)
        }
    }
    
    static func print(_ items: Any...) {
        if Logger.shouldLog {
            Swift.print(items)
        }
    }
}
